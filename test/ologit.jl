# Ordinal Models
@testset "Ordinal Models" begin
    data =
        dataset("Ecdat", "Kakadu") |>
        (data -> select(data, [:RecParks, :Sex, :Age, :Schooling]))
    data.RecParks = convert(Vector{Int}, data.RecParks)
    data.RecParks = levels!(categorical(data.RecParks, ordered = true), collect(1:5))
    model = fit(EconometricModel, @formula(RecParks ~ Age + Sex + Schooling), data)
    @test sprint(show, model) ==
          "Probability Model for Ordinal Response\nCategories: 1 < 2 < 3 < 4 < 5\nNumber of observations: 1827\nNull Loglikelihood: -2677.60\nLoglikelihood: -2657.40\nR-squared: 0.0075\nLR Test: 40.42 ∼ χ²(3) ⟹ Pr > χ² = 0.0000\nFormula: RecParks ~ Age + Sex + Schooling\n──────────────────────────────────────────────────────────────────────────────────────────\n                          PE          SE        t-value  Pr > |t|        2.50%      97.50%\n──────────────────────────────────────────────────────────────────────────────────────────\nAge                  0.00943647  0.00254031    3.71469     0.0002   0.00445424   0.0144187\nSex: male           -0.0151659   0.0846365    -0.179188    0.8578  -0.181161     0.150829\nSchooling           -0.103902    0.0248742    -4.17711     <1e-4   -0.152687    -0.0551174\n(Intercept): 1 | 2  -2.92405     0.191927    -15.2352      <1e-48  -3.30047     -2.54763\n(Intercept): 2 | 3  -1.54922     0.171444     -9.03632     <1e-18  -1.88547     -1.21297\n(Intercept): 3 | 4  -0.298938    0.166904     -1.79108     0.0734  -0.626281     0.0284051\n(Intercept): 4 | 5   0.669835    0.167622      3.9961      <1e-4    0.341083     0.998587\n──────────────────────────────────────────────────────────────────────────────────────────"
    β, V, σ = coef(model), vcov(model), stderror(model)
    @test β ≈ [
        0.009437926,
        -0.015143049,
        -0.103911316,
        -2.92391240,
        -1.549266200,
        -0.298963900,
        0.6698249,
    ] rtol = 1e-4
    @test V ≈ [
        0.00000646 -0.0000007000 0.000013250 0.00031473 0.0003161358 0.000321276 0.0003270734
        -0.00000070 0.0071633800 -0.000184930 0.00294759 0.0029647442 0.002995366 0.0029904485
        0.00001325 -0.0001849300 0.000618730 0.00288365 0.0028548209 0.002791361 0.0027318928
        0.00031473 0.0029475900 0.002883650 0.03684071 0.0289239290 0.026986237 0.026498765
        0.00031614 0.0029647400 0.002854820 0.02892393 0.0293971651 0.027160433 0.0266006675
        0.000321276 0.0029953660 0.002791361 0.02698623 0.0271604331 0.027860143 0.0270590982
        0.0003270734 0.002990448 0.002731893 0.02649876 0.0266006675 0.027059098 0.0281002038
    ] rtol = 1e-3
    @test σ ≈ [
        0.002540789,
        0.084636770,
        0.024874381,
        0.191939349,
        0.171456015,
        0.166913580,
        0.167631154,
    ] rtol = 1e-4
    data = data[data.RecParks.≠5, :]
    model = fit(EconometricModel, @formula(RecParks ~ Age + Sex + Schooling), data)
    @test sprint(show, model) ==
          "Probability Model for Ordinal Response\nCategories: 1 < 2 < 3 < 4\nNumber of observations: 1200\nNull Loglikelihood: -1502.61\nLoglikelihood: -1500.73\nR-squared: 0.0013\nLR Test: 3.76 ∼ χ²(3) ⟹ Pr > χ² = 0.2886\nFormula: RecParks ~ Age + Sex + Schooling\n───────────────────────────────────────────────────────────────────────────────────────────\n                          PE          SE        t-value  Pr > |t|        2.50%       97.50%\n───────────────────────────────────────────────────────────────────────────────────────────\nAge                  0.00063565  0.00329173    0.193105    0.8469  -0.00582255   0.00709385\nSex: male            0.0896101   0.106068      0.84484     0.3984  -0.118489     0.297709\nSchooling           -0.0509934   0.0300878    -1.69482     0.0904  -0.110024     0.00803731\n(Intercept): 1 | 2  -2.58123     0.228989    -11.2723      <1e-27  -3.0305      -2.13197\n(Intercept): 2 | 3  -1.12053     0.212192     -5.28071     <1e-6   -1.53684     -0.704217\n(Intercept): 3 | 4   0.486702    0.210541      2.31167     0.0210   0.0736316    0.899772\n───────────────────────────────────────────────────────────────────────────────────────────"
    β, V, σ = coef(model), vcov(model), stderror(model)
    @test β ≈ [0.00063565, 0.08961012, -0.05099339, -2.5812334, -1.1205278, 0.48670172] rtol =
        1e-4
    @test V ≈ [
        0.00001084 -5.386e-06 0.00002186 0.00052578 0.0005259 0.00052967
        -5.386e-06 0.01125032 -0.00021416 0.00465658 0.00470423 0.00484966
        0.00002186 -0.00021416 0.00090528 0.00435314 0.00431928 0.00424373
        0.00052578 0.00465658 0.00435314 0.05243606 0.04424607 0.04221716
        0.0005259 0.00470423 0.00431928 0.04424607 0.04502565 0.0424849
        0.00052967 0.00484966 0.00424373 0.04221716 0.0424849 0.04432745
    ] rtol = 1e-3
    @test σ ≈ [0.0032917, 0.1060675, 0.0300878, 0.2289892, 0.2121925, 0.2105408] rtol = 1e-4
    data =
        joinpath(dirname(pathof(Econometrics)), "..", "data", "auto.csv") |> CSV.File |> DataFrame |>
        (data -> select(data, [:rep77, :foreign, :length, :mpg])) |> dropmissing |>
        categorical!
    data.rep77 = levels!(
        categorical(data.rep77; ordered = true),
        ["Poor", "Fair", "Average", "Good", "Excellent"],
    )
    model = fit(EconometricModel, @formula(rep77 ~ foreign + length + mpg), data)
    @test sprint(show, model) ==
          "Probability Model for Ordinal Response\nCategories: Poor < Fair < Average < Good < Excellent\nNumber of observations: 66\nNull Loglikelihood: -89.90\nLoglikelihood: -78.25\nR-squared: 0.1295\nLR Test: 23.29 ∼ χ²(3) ⟹ Pr > χ² = 0.0000\nFormula: rep77 ~ foreign + length + mpg\n─────────────────────────────────────────────────────────────────────────────────────────────\n                                    PE         SE     t-value  Pr > |t|       2.50%    97.50%\n─────────────────────────────────────────────────────────────────────────────────────────────\nforeign: Foreign                2.89681    0.790641   3.66387    0.0005   1.31684     4.47678\nlength                          0.0828275  0.02272    3.64558    0.0005   0.0374253   0.12823\nmpg                             0.230768   0.0704548  3.2754     0.0017   0.0899749   0.37156\n(Intercept): Poor | Fair       17.9275     5.55119    3.22948    0.0020   6.83431    29.0206\n(Intercept): Fair | Average    19.8651     5.59648    3.54956    0.0007   8.68139    31.0487\n(Intercept): Average | Good    22.1033     5.70894    3.8717     0.0003  10.6949     33.5117\n(Intercept): Good | Excellent  24.6921     5.89075    4.19168    <1e-4   12.9204     36.4639\n─────────────────────────────────────────────────────────────────────────────────────────────"
    β, V, σ = coef(model), vcov(model), stderror(model)
    @test β ≈ [2.89679875, 0.08282676, 0.23076532, 17.92728, 19.86486, 22.10311, 24.69193] atol =
        1e-3
    @test V ≈ [
        0.62578335 0.0111044038 0.012321411 2.4421745 2.4836507 2.5750058 2.6957587
        0.0111044 0.0005186744 0.001222385 0.1243671 0.1258979 0.1284727 0.1319772
        0.01232141 0.0012223847 0.004974678 0.3328169 0.3368057 0.3430257 0.3549711
        2.44217451 0.1243670884 0.332816913 30.9544666 31.0279194 31.6005528 32.5099187
        2.48365067 0.1258979463 0.336805731 31.0279194 31.4396158 31.9986912 32.9170873
        2.57500582 0.1284726666 0.343025653 31.6005528 31.9986912 32.7044311 33.6189243
        2.69575871 0.1319772302 0.354971081 32.5099187 32.9170873 33.6189243 34.8533724
    ] rtol = 1e-2
    @test σ ≈ [
        0.79106469,
        0.02277442,
        0.07053140,
        5.56367384,
        5.60710405,
        5.71877881,
        5.90367448,
    ] rtol = 1e-2
end