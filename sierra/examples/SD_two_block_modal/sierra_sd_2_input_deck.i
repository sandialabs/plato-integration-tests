SOLUTION
  case '1'
  topology_optimization
  nmodes 30
  modalAdjointSolver = camp
  shift -5e8
  solver gdsw
END
PARAMETERS
  swapModes no
END
CAMP
  solver_tol 1e-4
  preconditioner gdsw
  max_iter 5000
END
INVERSE-PROBLEM
  data_truth_table dummy_eigen_ttable_1.txt
  data_file dummy_eigen_data_1.txt
  modal_data_file dummy_modal_data_1.txt
  modal_weight_table dummy_modal_weight_1.txt
  shape_sideset 4
  shape_bounds 1.0
  eigen_objective mpe
  design_variable shape
END
OPTIMIZATION
  optimization_package ROL_lib
  ROLmethod linesearch
  LSstep Newton-Krylov
  LS_curvature_condition null
  Max_iter_Krylov 50
  Use_FD_hessvec false
  Use_inexact_hessvec false
END
GDSW
  solver_tol = 1e-8
  SC_option 0
END
OUTPUTS
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
BLOCK 2
  material 1
END
TOPOLOGY-OPTIMIZATION
  algorithm = plato_engine
  case = inverse_methods
  inverse_method_objective = eigen-inverse
  ref_data_file gold-1.exo
  match_nodesets 1 2 3 4 5 6
  modes_to_exclude 1 2 3 4 5 6 11 12 13 14 15 16 17 18 19 20 21 22 23 24 25 26 27 28 29 30
  volume_fraction = .314
  objective_normalization false
END
FILE
  geometry_file 'two_block_modal.exo'
END
LOADS
END
BOUNDARY
END
begin contact definition
    skin all blocks = on
    begin interaction defaults
        general contact = on
        friction model = tied
    end interaction defaults
end

