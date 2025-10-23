SOLUTION
  eigen-inverse
  nmodes 4
  shift -1
  solver gdsw
END
INVERSE-PROBLEM
  shape_bounds 0.1 
  eigen_objective max 3
  design_variable shape
  shape_sideset all
END
OPTIMIZATION
END
GDSW
  solver_tol = 1e-8
END
MATERIAL 1
  isotropic
  E = 1.0e9
  nu = .333
  density = 4.5
END
BLOCK 1
  material 1
  Hex8f
END
LOADS
END
BOUNDARY
  sideset 1 fixed
END
