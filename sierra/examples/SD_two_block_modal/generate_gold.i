SOLUTION
  case '1'
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
  Tet4
END
BLOCK 2
  material 1
  Tet4
END
begin contact definition
    skin all blocks = on
    begin interaction defaults
        general contact = on
        friction model = tied
    end interaction defaults
end
FILE
  geometry_file 'gold.exo'
END
LOADS
END
BOUNDARY
END
