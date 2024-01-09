begin service 1  
  code platomain
  number_processors 1
end service

begin service 2
  code plato_analyze
  number_processors 1
end service

begin service 3
  code plato_esp
  number_processors 5
end service

begin criterion 1
  type mechanical_compliance
end criterion

begin criterion 2
  type volume
  minimum_ersatz_material_value 0
end criterion

begin scenario 1
  physics steady_state_mechanics
  dimensions 3
  loads 1 2
  boundary_conditions 1
  material 1
  linear_solver_tolerance 1e-6
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

begin boundary_condition 1
    type fixed_value
    location_type sideset
    location_name center_axis
    degree_of_freedom dispx dispz dispy
    value 0 0 0
end boundary_condition

begin load 1
    type traction
    location_type sideset
    location_name left_axis
    value 0 2e3 0
end load

begin load 2
    type traction
    location_type sideset
    location_name right_axis
    value 0 1e3 0
end load
      
begin block 1
   material 1
end block

begin material 1
   material_model isotropic_linear_elastic 
   poissons_ratio .33
   youngs_modulus 1e9
end material

begin optimization_parameters
   max_iterations 25
   output_frequency 1
   optimization_algorithm rol_bound_constrained
   normalize_in_aggregator false
   csm_file rocker.csm
   num_shape_design_variables 5
   optimization_type shape
end optimization_parameters

begin mesh
   name rocker.exo
end mesh

