SOLUTION
  eigen
  nmodes 30
  shift -5e8
  solver gdsw
END
PARAMETERS
  swapModes no
END
GDSW
  solver_tol = 1e-8
  SC_option 0
END
OUTPUTS
  disp
END
ECHO
END
MATERIAL 1
  isotropic
  E = 2.274e9
  nu = .42
  density = 2.59e-4
END
BLOCK 1
  material 1
END
FILE
  geometry_file 'whole_brick.exo'
END
LOADS
END
BOUNDARY
END