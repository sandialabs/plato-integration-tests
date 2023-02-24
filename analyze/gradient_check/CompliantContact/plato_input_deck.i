begin service 1
  code platomain
  number_processors 1
  number_ranks 1
end service

begin service 2
  code plato_analyze
  number_processors 1
  number_ranks 1
end service

begin criterion 1
  type mechanical_compliance
  minimum_ersatz_material_value 1e-6
end criterion

begin criterion 2
  type volume
end criterion

begin scenario 1
  physics steady_state_mechanics
  dimensions 3
  loads 1 
  boundary_conditions 1
  material 1
  minimum_ersatz_material_value 1e-6
  linear_solver_tolerance 1e-8
end scenario

begin objective
  type single_criterion
  criteria 1 
  services 2 
  scenarios 1 
end objective

begin output
  service 2
  output_data true
  data dispx dispy dispz
end output

begin boundary_condition 1
  type fixed_value
  location_type nodeset
  location_name ns_right_right
  degree_of_freedom dispx dispz dispy
  value 0 0 0
end boundary_condition

begin load 1
    type traction
    location_type sideset
    location_name ss_left_left
    value 4.0e7 0 0
end load

begin constraint 1
  criterion 2
  relative_target 0.25
  type less_than
  service 1
end constraint

begin block 1
   material 1
end block

begin block 2
   material 1
end block

begin material 1
   material_model isotropic_linear_elastic 
   poissons_ratio .3
   youngs_modulus 1e8
end material

begin optimization_parameters
   check_gradient true
   rol_gradient_check_perturbation_scale 0.1
   rol_gradient_check_steps 12
   rol_gradient_check_random_seed 123
   verbose true
   filter_radius_scale 1.5
   max_iterations 1 
   output_frequency 1000 
   optimization_algorithm rol_augmented_lagrangian
   rol_subproblem_model lin_more
   discretization density 
   initial_density_value .25
   normalize_in_aggregator false
   rol_lin_more_cauchy_initial_step_size 3.1
end optimization_parameters

begin mesh
   name ball_in_cup.exo
end mesh

