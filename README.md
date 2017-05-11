# CGE-in-Julia
*Completed in partial fulfillment of ER290A: Computational Methods in Economics*

*Summary:* This repository will contain a simple CGE model in Julia based on an EcoMod CGE instruction module. The final product represents a two-sector economy with two firms and one household that maximize profits and utility according to a CES production function and a LES utility function, respectively.  The model uses the JuMP package in place of GAMS as a mathematical descriptor; both systems employ Ipopt as a non-linear optimization solver. The GitHub for this project can be accessed at: https://github.com/vnvasquez/CGE-in-Julia

*Longform:* The project herein replicates a computable general equilibrium (CGE) model that is drawn from a Global Economic Modeling Network (EcoMod) training example. It translates this simple non-linear model from General Algebraic Modeling System (GAMS) into Julia code.

The model, which portrays a two-sector economy, has two firms and one household. The firms each produce a single commodity. The household is the sole consumer of these two commodities. All three entities are assumed to maximize their profits and utility; the firms do this according to a constant elasticity of substitution (CES) production function and the household according to a Linear Expenditure System (LES) utility function. The LES utility function is subject to a budget constraint.  

Importantly, the model uses the JuMP package in place of GAMS as a mathematical descriptor. By definition, both the original GAMs iteration and the replicated JuMP version employ Ipopt as their non-linear optimization solver. Therefore when converting the GAMS configuration into Julia, we used the latter language’s Ipopt and DataFrames packages in addition to JuMP. The DataFrames package enabled us to create and view our results in a manageable format.

We used indices to assign parameter values where necessary, dividing the model economy into its two sectors – production and consumption – in the process of doing so. We chose this approach rather than reading data in wholesale using a .csv file due to the computational limitations of using, for example, JuMP rather than Mimi. This is a clear area for further improving our project in the future, and avenue that we intend to pursue.  

Parameter values included both initial values such as capital and labor demand as well as endowment figures for capital and labor. Technical coefficients such as the elasticity of substitution between factors in the production function, and the Frisch parameter – the elasticity of the marginal utility of expenditure – are also added to the model in this subsection of the project, among other elements.  

The model features block format to enter variables; we chose to create separate variable blocks for production and consumption. Each variable within each block is indexed appropriately in order to connect it with its starting parameter values, as needed. We selected this block format approach with the intention of generating code that is both easily read and simple to expand. This will be useful in the coming months: we intend to build out this extremely simply model a great deal, such that it includes a number of additional sectors, firms, and households. We believe that assigning variables to blocks rather than using the overtly verbose method of entering each variable on its own line will save time in this later endeavor.

Similarly, constraints – known as equations in the GAMS version of the model – are entered in block format. This serves the same purpose as explained above and furnishes an accessible means of categorizing the relationships between variables according to whether they are in the consumption or production block.
 
Upon running the model, we initially found that our results diverged from those which were expected. *[INSERT MORE HERE WHEN IT’S WORKING PROPERLY].*
