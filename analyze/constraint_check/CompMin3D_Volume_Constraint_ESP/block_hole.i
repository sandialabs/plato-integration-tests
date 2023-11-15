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
   number_processors 1
end service

begin criterion 1
   type mechanical_compliance
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
   tolerance 1e-6
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
   data dispx dispy dispz
end output

begin boundary_condition 1
   type fixed_value
   location_type sideset
   location_name fixed_ss
   degree_of_freedom dispx dispz dispy
   value 0 0 0
end boundary_condition

begin load 1
   type traction
   location_type sideset
   location_name load_ss
   value 0 2e3 0
end load

begin constraint 1
   criterion 2
   absolute_target 950 
   service 2
   scenario 1
end constraint

begin block 1
   material 1
   name block_1_tet
end block

begin material 1
   material_model isotropic_linear_elastic 
   poissons_ratio .33
   youngs_modulus 1e9
end material

begin optimization_parameters
   max_iterations 50 
   output_frequency 5
   optimization_algorithm rol_augmented_lagrangian
   normalize_in_aggregator false
   csm_file block_hole.csm
   num_shape_design_variables 1
   optimization_type shape
   verbose true
   number_buffer_layers 0
   rol_initial_trust_region_radius 1
   check_gradient true
   rol_gradient_check_perturbation_scale 0.2
   rol_gradient_check_steps 8
   rol_gradient_check_random_seed 123
end optimization_parameters


   begin mesh
      name block_hole.exo
   end mesh
