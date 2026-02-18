SOLUTION
  eigen-inverse
  nmodes 16
  shift -1e-4 #B-div
  solver gdsw
  
END
INVERSE-PROBLEM
  shape_bounds 0.1 
  eigen_objective max sum 7:10  #comment out to run with matching objective 
  design_variable shape
  shape_sideset surface__void
END
OPTIMIZATION
END

GDSW
END

BOUNDARY  
END

OUTPUTS
disp
energy
END

ECHO
END

MATERIAL 1
  isotropic
  E = 4.000000
  nu = .3
  density = 2.00000000
END

BLOCK 1
  material 1
  Hex8f
END

LOADS
END
