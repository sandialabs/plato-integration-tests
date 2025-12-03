begin density_topology
    mesh_name bolted_bracket_disp.exo
    output_name to-result.exo
    initial_density_value 0.25
end

begin kernel_filter
    filter_radius 3.
    centering_type node
    use_relative_radius true
end

begin constraint volume
    active true
    app platoanalyze
    criterion platoanalyze
    input_files plato_analyze_volume.xml
    is_linear true
    constraint_value 2.23
    constraint_type equal_to
end

begin objective displacement
    active true
    app platoanalyze
    criterion platoanalyze
    input_files plato_analyze_displacement.xml
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
