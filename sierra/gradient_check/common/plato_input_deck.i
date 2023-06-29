begin service 1  
  code platomain
  number_processors 1
end service

begin service 2
  code sierra_sd
  number_processors 1
  cache_state true
end service

begin service 3
  code plato_esp
  number_processors 1
end service

begin criterion 1
  type modal_projection_error
  num_modes_compute 2
  modes_to_exclude 1 
  eigen_solver_shift -5e8
  camp_solver_tol 1e-4
  camp_max_iter 5000
  shape_sideset 3
  ref_data_file gold_brick-out.exo
  match_nodesets 4 5 6 7 8 9
end criterion

begin criterion 2
  type volume
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

begin material 1
   material_model isotropic_linear_elastic 
   poissons_ratio .42
   youngs_modulus 2.274e9
   mass_density 2.59e-4
end material

begin optimization_parameters
   esp_workflow aflr4_aflr3 #egads_tetgen

check_gradient true
   rol_gradient_check_perturbation_scale 0.01
   rol_gradient_check_steps 12
   problem_update_frequency 1
   max_iterations 15
   output_frequency 1
   optimization_algorithm rol_bound_constrained 
   rol_subproblem_model lin_more
   hessian_type zero
   normalize_in_aggregator false
   csm_file brick.csm
   num_shape_design_variables 3
   optimization_type shape
   verbose true
end optimization_parameters

begin mesh
   name brick.exo
end mesh
