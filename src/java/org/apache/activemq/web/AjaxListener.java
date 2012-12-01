/**
 * Licensed to the Apache Software Foundation (ASF) under one or more
 * contributor license agreements.  See the NOTICE file distributed with
 * this work for additional information regarding copyright ownership.
 * The ASF licenses this file to You under the Apache License, Version 2.0
 * (the "License"); you may not use this file except in compliance with
 * the License.  You may obtain a copy of the License at
 *
 *      http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */
package org.apache.activemq.web;

import javax.jms.Message;
import javax.jms.MessageConsumer;

import org.eclipse.jetty.continuation.Continuation;
import org.eclipse.jetty.continuation.ContinuationSupport;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import org.apache.activemq.MessageAvailableListener;

import java.util.LinkedList;

/*
 * Listen for available messages and wakeup any continuations.
 */
public class AjaxListener implements MessageAvailableListener {
    private static final Logger LOG = LoggerFactory.getLogger(AjaxListener.class);
    
    private long maximumReadTimeout;
    private AjaxWebClient client;
    private long lastAccess;
    private Continuation continuation;
    private LinkedList<UndeliveredAjaxMessage> undeliveredMessages = new LinkedList<UndeliveredAjaxMessage>();

    AjaxListener(AjaxWebClient client, long maximumReadTimeout) {
        this.client = client;
        this.maximumReadTimeout = maximumReadTimeout;
        access();
    }

    public void access() {
        lastAccess = System.currentTimeMillis();
    }

    public synchronized void setContinuation(Continuation continuation) {
        this.continuation = continuation;
    }

    public LinkedList<UndeliveredAjaxMessage> getUndeliveredMessages() {
        return undeliveredMessages;
    }
    
    public synchronized void onMessageAvailable(MessageConsumer consumer) {
        if (LOG.isDebugEnabled()) {
            LOG.debug("message for " + consumer + " continuation=" + continuation);
        }
        
        if (continuation != null) {
            
            try {
                Message message = consumer.receive(10);
                LOG.debug( "message is " + message );
                if( message != null ) {
                    
                    if(false && continuation.isSuspended() ) {
                        
                        LOG.debug( "Resuming suspended continuation " + continuation );
                        continuation.setAttribute("undelivered_message", new UndeliveredAjaxMessage( message, consumer ) );
                        continuation.resume();
                    } else {
                        LOG.debug( "Message available, but continuation is already resumed.  Buffer for next time." );
                        bufferMessageForDelivery( message, consumer );
                    }
                }
            } catch (Exception e) {
                LOG.error("Error receiving message " + e, e);
            }
            
        } else if (System.currentTimeMillis() - lastAccess > 2 * this.maximumReadTimeout) {
            new Thread() {
                public void run() {
                    client.closeConsumers();
                };
            }.start();
        } else {
            try {
                Message message = consumer.receive(10);
                bufferMessageForDelivery( message, consumer );
            } catch (Exception e) {
                LOG.error("Error receiving message " + e, e);
            }
        }
    }
    
    public void bufferMessageForDelivery( Message message, MessageConsumer consumer ) {
        if( message != null ) {
            synchronized( undeliveredMessages ) {
                undeliveredMessages.addLast( new UndeliveredAjaxMessage( message, consumer ) );
            }
        }
    }
}
