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
  minimum_ersatz_material_value 1e-3
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
  minimum_ersatz_material_value 1e-3
  linear_solver_tolerance 1e-10
end scenario

begin objective
  type weighted_sum
  criteria 1 
  services 2 
  scenarios 1 
  weights 1 
end objective

begin output
    service 2
   output_data true
   data dispx dispy dispz vonmises
end output

begin boundary_condition 1
    type fixed_value
    location_type sideset
    location_name sideset1
    degree_of_freedom dispx dispz dispy
    value 0 0 0
end boundary_condition

begin load 1
    type traction
    location_type sideset
    location_name sideset2
    value 0 -5000 0
end load

begin constraint 1
  criterion 2
  relative_target 0.25
  type less_than
  service 1
end constraint

begin block 1
   material 1
   element_type hex8
end block

begin material 1
   material_model isotropic_linear_elastic 
   poissons_ratio .3
   youngs_modulus 1e8
end material

begin optimization_parameters
   verbose true
   filter_radius_scale 1.5
   max_iterations 1 
   output_frequency 1000 
   optimization_algorithm rol_augmented_lagrangian
   rol_subproblem_model lin_more
   discretization density 
   initial_density_value .25
   normalize_in_aggregator false
   oc_objective_stagnation_tolerance 1e-14
   oc_control_stagnation_tolerance 1e-14
   rol_lin_more_cauchy_initial_step_size 3.1
end optimization_parameters

begin mesh
   name rect.exo
end mesh

