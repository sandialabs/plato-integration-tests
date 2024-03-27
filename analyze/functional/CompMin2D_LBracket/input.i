begin density_topology
    mesh_name lbracket.exo
    output_name to-result.exo
    filter_type helmholtz
    filter_radius 2.5e-2
end

begin constraint volume
    active true
    app custom_app
    shared_library_path libAnalyzeFunctionalInterface.so
    input_files plato_analyze_vol.xml
    is_linear true
    equal_to 0.32
end

begin objective compliance
    active true
    app custom_app
    shared_library_path libAnalyzeFunctionalInterface.so
    input_files plato_analyze_to.xml
    aggregation_weight 1.0
    objective_type minimize
end

begin optimization_parameters
    input_file_name rol_inputs.xml
    step_tolerance 1e-10
    gradient_tolerance 1e-5
    max_iterations 10
end

begin gradient_check
    output_file_name ROL_gradient_check_output.txt
    number_of_steps 10
    initial_direction_magnitude 1
    step_size_reduction_factor 0.1
    random_direction_seed 1
end
