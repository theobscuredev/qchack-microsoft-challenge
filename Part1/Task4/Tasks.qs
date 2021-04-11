namespace QCHack.Task4 {
    open Microsoft.Quantum.Canon;
    open Microsoft.Quantum.Intrinsic;

    // Task 4 (12 points). f(x) = 1 if the graph edge coloring is triangle-free
    // 
    // Inputs:
    //      1) The number of vertices in the graph "V" (V ≤ 6).
    //      2) An array of E tuples of integers "edges", representing the edges of the graph (0 ≤ E ≤ V(V-1)/2).
    //         Each tuple gives the indices of the start and the end vertices of the edge.
    //         The vertices are indexed 0 through V - 1.
    //         The graph is undirected, so the order of the start and the end vertices in the edge doesn't matter.
    //      3) An array of E qubits "colorsRegister" that encodes the color assignments of the edges.
    //         Each color will be 0 or 1 (stored in 1 qubit).
    //         The colors of edges in this array are given in the same order as the edges in the "edges" array.
    //      4) A qubit "target" in an arbitrary state.
    //
    // Goal: Implement a marking oracle for function f(x) = 1 if
    //       the coloring of the edges of the given graph described by this colors assignment is triangle-free, i.e.,
    //       no triangle of edges connecting 3 vertices has all three edges in the same color.
    //
    // Example: a graph with 3 vertices and 3 edges [(0, 1), (1, 2), (2, 0)] has one triangle.
    // The result of applying the operation to state (|001⟩ + |110⟩ + |111⟩)/√3 ⊗ |0⟩ 
    // will be 1/√3|001⟩ ⊗ |1⟩ + 1/√3|110⟩ ⊗ |1⟩ + 1/√3|111⟩ ⊗ |0⟩.
    // The first two terms describe triangle-free colorings, 
    // and the last term describes a coloring where all edges of the triangle have the same color.
    //
    // In this task you are not allowed to use quantum gates that use more qubits than the number of edges in the graph,
    // unless there are 3 or less edges in the graph. For example, if the graph has 4 edges, you can only use 4-qubit gates or less.
    // You are guaranteed that in tests that have 4 or more edges in the graph the number of triangles in the graph 
    // will be strictly less than the number of edges.
    //
    // Hint: Make use of helper functions and helper operations, and avoid trying to fit the complete
    //       implementation into a single operation - it's not impossible but make your code less readable.
    //       GraphColoring kata has an example of implementing oracles for a similar task.
    //
    // Hint: Remember that you can examine the inputs and the intermediary results of your computations
    //       using Message function for classical values and DumpMachine for quantum states.
    //
    operation ValidTriangle (inputs : Qubit[], output : Qubit) : Unit is Adj+Ctl {
        for i in 0 .. (Length(inputs)-1) {
            X(inputs[i]);
            Controlled X(inputs, output);
            X(inputs[i]);
        }
        X(inputs[0]);
        X(inputs[1]);
        Controlled X(inputs, output);
        X(inputs[0]);
        
        X(inputs[2]);
        Controlled X(inputs, output);
        X(inputs[1]);

        X(inputs[0]);
        Controlled X(inputs, output);
        X(inputs[0]);
        X(inputs[2]);
    }
    
    function GetTriangle(V: Int, edges : (Int, Int)[]) : (Int, Int, Int)[] {
        let n = Length(edges);
        mutable count = 0;
        mutable triplets = new (Int, Int, Int)[n];

        // a triplet containing three edges has a total of 3 distinct vertices iff it represents a triangle
        // given that we don't have loops (singleton circles) in edge list
        for i in 0 .. (n-1) {
            let (e1l, e1r) = edges[i];
            for j in (i+1) .. (n-1){
                let (e2l, e2r) = edges[j];
                for k in (j+1) .. (n-1) {
                    let (e3l, e3r) = edges[k];
                    
                    let uniqueV = Unique(EqualI, [e1l, e1r, e2l, e2r, e3l, e3r]);
                    if Length(uniqueV == 3) {
                        set triplets w/= count <- (i, j, k);
                        set count += 1;
                    }
                }
            }
        }

        return triplets[0 .. (count-1)];
    }



    operation Task4_TriangleFreeColoringOracle (
        V : Int, 
        edges : (Int, Int)[], 
        colorsRegister : Qubit[], 
        target : Qubit
    ) : Unit is Adj+Ctl {
        // ...
    }
}

