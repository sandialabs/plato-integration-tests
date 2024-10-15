
Begin sierra OptRun

  Begin TPETRA equation solver linear_solver

    Begin CG solver 

      Begin jacobi preconditioner 
      End jacobi preconditioner

      maximum iterations = 1000
      residual scaling = R0
      convergence tolerance = 1e-08
    End CG solver

  End TPETRA equation solver


  Begin Universal Aria Expressions 
  End Universal Aria Expressions

  

  ########################################
  ###       Material Definitions       ###
  ########################################
  
    Begin Aria Material MatA
        Density              = Constant rho = 2702. # kg/m^3, at 20 C
        Specific Heat        = Constant cp  = 903.  # J/kg-K, at 20 C
        Thermal Conductivity = Constant k = 10000000.  # W/mK
       $ Thermal Conductivity = Constant k = 200.  # W/mK
        Heat Conduction      = Basic
    End   Aria Material MatA

    Begin Finite Element Model FEModel
        Database Name = gold_mesh.exo
        decomposition method =  rcb
        Use Material MatA for block_1
    End   Finite Element Model FEModel


  Begin procedure ariaProcedure

    Begin solution control description 
      Use System Main

      Begin parameters for transient time_stepping_block
        start time = 0
        termination time = 3600

        Begin parameters for Aria region AriaRegion
          initial time step size = 600
          #minimum time step size = 0.001
          #maximum time step size = 100
          #predictor-corrector tolerance = 0.0005
          time integration method = first_order
          #time integration method = bdf2
          time step variation = fixed
          #failed time step size ratio = 0.5
          #maximum time step size ratio = 1.25
        End parameters for Aria region

      End parameters for transient


      Begin System Main 
        Simulation Start Time = 0
        Simulation Termination Time = 3600

        Begin Transient time_stepping_block
          advance AriaRegion
        End Transient

      End System Main

    End solution control description


    Begin aria region AriaRegion
      EQ energy for temperature on block_1 using Q1 with diff lumped_mass src
      

      ########################################
      ###        Initial Conditions        ###
      ########################################
      
      # Beginning of Initial Conditions 
        IC for temperature on block_1 = constant value = 0
      # End of Initial Conditions 
      
      Source for energy on block_1 = constant value = 0
      #Source for energy on block_1 = Optimization value = 0
      #Compute Shape Gradient on surface_13

      ########################################
      ###       Boundary Conditions        ###
      ########################################

      BC flux for energy on surface_2 = Constant  value = 5e6
      BC dirichlet for temperature on surface_1 = constant value = 20.

      use finite element model FEModel
      use linear solver linear_solver
      nonlinear residual tolerance = 1e-06
      maximum nonlinear iterations = 10
      minimum nonlinear iterations = 1
      nonlinear relaxation factor = 1.0
      accept solution after maximum nonlinear iterations = False
      

      ########################################
      ###          Results Output          ###
      ########################################
      
      Begin results output myoutput
        database name = {output_filename="gold.exo"}
        at step 0, increment = 1
        nodal variables = solution->temperature as T_K
      End results output

    End aria region

  End procedure

End sierra
