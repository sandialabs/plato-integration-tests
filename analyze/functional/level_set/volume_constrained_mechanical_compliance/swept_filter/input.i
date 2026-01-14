begin level_set_topology
    mesh_name rect_side.exo
    output_name level-set-result.exo
    include_void_region true
    sphere_list radius 2 center (0,0,0)
    level_set_bounds [-0.5, 0.5]
    max_edge_length_percentage_for_snapping 0
end

begin z_swept_filter
    filter_radius 1.5
    target_mesh_name rect.exo
    centering_type node
end

begin constraint volume
    active true
    app platoanalyze
    criterion platoanalyze
    input_files plato_analyze_volume.xml
    is_linear false
    constraint_value 38
    constraint_type equal_to
end

begin objective compliance
    active true
    app platoanalyze
    criterion platoanalyze
    input_files plato_analyze_compliance.xml
    aggregation_weight 1.0
end

#begin rol_optimization
#    max_iterations 15
#    rol_input_file rol_inputs_AL.xml
#end

begin gradient_check
    output_file_name ROL_gradient_check_output.txt
    number_of_steps 10
    initial_direction_magnitude 0.1
    step_size_reduction_factor 0.1
    random_direction_seed 1
    direction_vector_type uniform_positive
end

begin constraint_check
    linearity_check_output_file_name ROL_constraint_linearity_check_output.txt
    jacobian_check_output_file_name ROL_constraint_jacobian_check_output.txt
    jacobian_adjoint_consistency_output_file_name ROL_constraint_jacobian_adjoint_consistency_check_output.txt
    number_of_steps 10
    initial_direction_magnitude 0.1
    step_size_reduction_factor 0.1
    random_direction_seed 1
    direction_vector_type uniform_positive
end
