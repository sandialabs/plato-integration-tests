begin service 1  
  code platomain
  number_processors 1
end service

begin service 2
  code sierra_sd
  number_processors 1
  cache_state true
  //path /fgs/bwclark/sierra_master/bin/linux-gcc-10.2.0-openmpi-4.0.5/release/plato_sd_main
end service

begin service 3
  code plato_esp
  number_processors 1
end service

begin criterion 1
  type modal_projection_error
  num_modes_compute 30
  modes_to_exclude 1 2 3 4 5 6 11 12 13 14 15 16 17 18 19 20 21 22 23 24 25 26 27 28 29 30
  eigen_solver_shift -5e8
  camp_solver_tol 1e-4
  camp_max_iter 5000
  shape_sideset 4
  ref_data_file gold-1.exo
  match_nodesets 1 2 3 4 5 6
end criterion

begin scenario 1
  physics modal_response
  dimensions 3
  material 1
  tolerance 1e-8
end scenario

begin objective
  type weighted_sum
  criteria 1
  services 2
  shape_services 3
  scenarios 1
  weights 1
end objective

begin output
   service 2
   output_data true
   data dispx dispy dispz
end output

begin block 1
   material 1
end block

begin block 2
   material 1
end block

begin material 1
   material_model isotropic_linear_elastic 
   poissons_ratio .42
   youngs_modulus 2.274e9
   mass_density 2.59e-4
end material

begin optimization_parameters
   max_iterations 50
   output_frequency 100
   optimization_algorithm rol_bound_constrained
   rol_subproblem_model lin_more
   hessian_type zero
   normalize_in_aggregator false
   csm_file two_block_modal.csm
   num_shape_design_variables 1
   optimization_type shape
   verbose true
   esp_workflow egads_tetgen
end optimization_parameters

begin mesh
   name two_block_modal.exo
end mesh
