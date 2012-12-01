/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */
package com.feezixlabs.util;

import com.feezixlabs.bean.Pad;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.List;

/**
 *
 * @author bitlooter
 */
public class PadSorter {
  private final int MAX_VERTS;

  private Pad vertexList[]; // list of vertices

  private int matrix[][]; // adjacency matrix

  private int numVerts; // current number of vertices

  private Pad sortedArray[];

  public PadSorter(int MAX_VERTS) {
    this.MAX_VERTS = MAX_VERTS;
    vertexList = new Pad[MAX_VERTS];
    matrix = new int[MAX_VERTS][MAX_VERTS];
    numVerts = 0;
    for (int i = 0; i < MAX_VERTS; i++)
      for (int k = 0; k < MAX_VERTS; k++)
        matrix[i][k] = 0;
    sortedArray = new Pad[MAX_VERTS]; // sorted vert labels
  }

  public void addVertex(Pad node) {
    vertexList[numVerts++] = node;
  }

  public void addEdge(int start, int end) {
    matrix[start][end] = 1;
  }

  public void displayVertex(int v) {
    //System.out.print(vertexList[v].label);
  }

  public List<Pad> topo() // toplogical sort
  {
    int orig_nVerts = numVerts; 

    while (numVerts > 0) // while vertices remain,
    {
      // get a vertex with no successors, or -1
      int currentVertex = noSuccessors();
      if (currentVertex == -1) // must be a cycle
      {
        System.out.println("ERROR: Graph has cycles");
        return null;
      }
      // insert vertex label in sorted array (start at end)
      sortedArray[numVerts - 1] = vertexList[currentVertex];

      deleteVertex(currentVertex); // delete vertex
    }

    // vertices all gone; display sortedArray
    //System.out.print("Topologically sorted order: ");
    /*for (int j = 0; j < orig_nVerts; j++)
      System.out.print(sortedArray[j].getId()+",");
    System.out.println("");*/
    
    
     List<Pad> result = new ArrayList<Pad>();
     result.addAll(Arrays.asList(sortedArray));
      
     return result;    
  }
  

  public int getPadIndex(int id,List<Pad> pads){
      for(int i=0;i<pads.size();i++)
          if(pads.get(i).getId() == id)return i;
      return -1;
  }
  
  public static List<Pad> topo(List<Pad> pads){
      PadSorter sorter = new PadSorter(pads.size()+1);
      Pad root = new Pad();
      root.setId(0);
      sorter.addVertex(root);
      
      for(int i=0;i<pads.size();i++){
          sorter.addVertex(pads.get(i));
          sorter.addEdge(i+1,sorter.getPadIndex(pads.get(i).getParentId(),pads)+1);
      }
      return sorter.topo();
  }
  
  
  public static List<Pad> topo_siblings(List<Pad> pads){
      PadSorter sorter = new PadSorter(pads.size()+1);
      Pad root = new Pad();
      root.setId(0);
      sorter.addVertex(root);
      
      for(int i=0;i<pads.size();i++){
          sorter.addVertex(pads.get(i));
          sorter.addEdge(i+1,sorter.getPadIndex(pads.get(i).getPreSibling(),pads)+1);
      }
      return sorter.topo();
  }  

  public int noSuccessors() // returns vert with no successors (or -1 if no such verts)
  { 
    boolean isEdge; // edge from row to column in adjMat

    for (int row = 0; row < numVerts; row++) {
      isEdge = false; // check edges
      for (int col = 0; col < numVerts; col++) {
        if (matrix[row][col] > 0) // if edge to another,
        {
          isEdge = true;
          break; // this vertex has a successor try another
        }
      }
      if (!isEdge) // if no edges, has no successors
        return row;
    }
    return -1; // no
  }

  public void deleteVertex(int delVert) {
    if (delVert != numVerts - 1) // if not last vertex, delete from vertexList
    {
      for (int j = delVert; j < numVerts - 1; j++)
        vertexList[j] = vertexList[j + 1];

      for (int row = delVert; row < numVerts - 1; row++)
        moveRowUp(row, numVerts);

      for (int col = delVert; col < numVerts - 1; col++)
        moveColLeft(col, numVerts - 1);
    }
    numVerts--; // one less vertex
  }

  private void moveRowUp(int row, int length) {
    for (int col = 0; col < length; col++)
      matrix[row][col] = matrix[row + 1][col];
  }

  private void moveColLeft(int col, int length) {
    for (int row = 0; row < length; row++)
      matrix[row][col] = matrix[row][col + 1];
  }

  /*
  public static void main(String[] args) {
    GraphTS g = new GraphTS();
    g.addVertex('A'); // 0
    g.addVertex('B'); // 1
    g.addVertex('C'); // 2
    g.addVertex('D'); // 3
    g.addVertex('E'); // 4
    g.addVertex('F'); // 5
    g.addVertex('G'); // 6
    g.addVertex('H'); // 7

    g.addEdge(0, 3); // AD
    g.addEdge(0, 4); // AE
    g.addEdge(1, 4); // BE
    g.addEdge(2, 5); // CF
    g.addEdge(3, 6); // DG
    g.addEdge(4, 6); // EG
    g.addEdge(5, 7); // FH
    g.addEdge(6, 7); // GH

    g.topo(); // do the sort
  }    */
}
