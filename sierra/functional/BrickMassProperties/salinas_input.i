SOLUTION
  case '1'
  statics
END
GDSW
  solver_tol = 1e-8
END
OUTPUTS
END
ECHO
mass=block
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

FILE
  geometry_file 'brick.exo'
END
LOADS
END
BOUNDARY
END
