begin density_topology
    mesh_name cube_quadrant.exo
    output_name reflected-result.exo
    initial_density_value 0.5
end

begin positive_octant_reflect_filter
    filter_radius 1.25
    target_mesh_name cube.exo
    centering_type node
end

begin constraint volume
    active true
    app platoanalyze
    criterion platoanalyze
    input_files plato_analyze_volume.xml
    is_linear true
    constraint_value 500
    constraint_type equal_to
end

begin objective compliance
    active true
    app platoanalyze
    criterion platoanalyze
    input_files plato_analyze_compliance.xml
    aggregation_weight 1.0
end

begin rol_optimization
    max_iterations 5
end

begin gradient_check
    output_file_name ROL_gradient_check_output.txt
    number_of_steps 10
    initial_direction_magnitude 1
    step_size_reduction_factor 0.1
    random_direction_seed 1
    direction_vector_type random
end

begin constraint_check
    linearity_check_output_file_name ROL_constraint_linearity_check_output.txt
    jacobian_check_output_file_name ROL_constraint_jacobian_check_output.txt
    jacobian_adjoint_consistency_output_file_name ROL_constraint_jacobian_adjoint_consistency_check_output.txt
    number_of_steps 2
    initial_direction_magnitude 1
    step_size_reduction_factor 0.1
    random_direction_seed 123
    direction_vector_type random
end
