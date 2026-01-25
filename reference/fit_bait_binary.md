# Fits the responses in a BAIT binary logistic regression model for each respondent group

Uses the `apollo` package for modelling.

## Usage

``` r
fit_bait_binary(elimination_threshold = 0.2)
```

## Arguments

- elimination_threshold:

  Performs step-wise backward elimination of least significant
  coefficients using p \> `elimination_threshold`. Default: 0.20. To
  disable backward elimination of coefficients set elimination_threshold
  = 1

## Examples

``` r
fit_bait_binary()
#> 
#> 
#>              . ,,                                                            
#>             ,      ,,                                                        
#>  ,,,,,,    ,         ,,                                                      
#> ,     ,,  ,            ,,,,.                                                 
#> ,,     , ,,   ,,,,,,    ,,,                                 //  //           
#>   ,     ,,,.   ,,,,,.   ,,      ////                        //  //           
#> ,,     ,,,,,.           ,,     // //     //////    /////    //  //    /////  
#> ,,,        ,,           ,      //  //    /    //  //   //   //  //   //   // 
#>               ,,       ,      ////////   /    //  //   //   //  //   //   // 
#>                 ,,   ,,      //     //   /   ///  //   //   //  //   //   // 
#>                    ,         //      //  /////      ///      //  //    ///   
#>                                          //                                  
#>                                          //                                  
#> 
#> Apollo 0.3.6
#> https://www.ApolloChoiceModelling.com
#> See url for a detailed manual, examples and a user forum.
#> Sign up to the user forum to receive updates on new releases.
#> 
#> Please cite Apollo in all written material you produce:
#> Hess S, Palma D (2019). "Apollo: a flexible, powerful and customisable
#> freeware package for choice model estimation and application." Journal
#> of Choice Modelling, 32. doi.org/10.1016/j.jocm.2019.100170
#> 
#> The developers of Apollo acknowledge the substantial support provided by
#> the European Research Council (ERC) through the consolidator grant DECISIONS,
#> the proof of concept grant APOLLO, and the advanced grant SYNERGY.
```
