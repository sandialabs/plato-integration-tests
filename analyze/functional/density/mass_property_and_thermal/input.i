begin density_topology
    mesh_name square.exo
    output_name to-result.exo
    initial_density_value 0.7
    fixed_blocks fixed_block
end

begin kernel_filter
    filter_radius 2
    centering_type node
    use_relative_radius true
end

begin objective mass_properties
    active true
    app platoanalyze
    criterion platoanalyze
    input_files plato_analyze_mass_properties.xml
    aggregation_weight 1000
end

begin objective thermal_compliance
    active true
    app platoanalyze
    criterion platoanalyze
    input_files plato_analyze_thermal_compliance.xml
    aggregation_weight 1.0e-5
end

begin rol_optimization
    max_iterations 5
    approximate_hessian true
end

begin gradient_check
    output_file_name ROL_gradient_check.txt
    number_of_steps 20
    initial_direction_magnitude 1
    step_size_reduction_factor 0.5
    random_direction_seed 1
end
