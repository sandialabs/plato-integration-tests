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
  E = 0.69
  nu = .3
  density = 2.7
END

BLOCK 1 2
  material 1
END

LOADS
END
BOUNDARY
END
