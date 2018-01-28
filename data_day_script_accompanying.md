---
title: "Data Day Accompanying Script"
author: "Emily Robinson"
date: "1/23/2018"
output: 
  html_document:
    keep_md: TRUE
---



## Reading in the data

We'll try the base R way first. 


```r
multiple_choice_responses_base <- read.csv("multipleChoiceResponses.csv")
# multiple_choice_responses_base
```

Let's say we wanted to know the numbers of NAs in each column. We can use `is.na` to change each entry in a column to TRUE or FALSE, depending on whether it's NA, and then sum the column (because `TRUE` evaluates as 1 and `FALSE` as 0) to get the total number of NAs. 

To do this for every column, we can use `purrr::map_df`, which applies the given function over the whole dataset, column by column, and returns a dataframe with the same column name and one row representing the number of NAs in each column. If you're used to the `apply` family of functions, `purrr` offers the same capabilities in a more consistent way.  


```r
# for one column
sum(is.na(multiple_choice_responses_base$Country))
```

```
## [1] 0
```

```r
# for every column 
multiple_choice_responses_base %>%
  purrr::map_df(~sum(is.na(.)))
```

```
## # A tibble: 1 x 228
##   GenderSelect Country   Age EmploymentStatus StudentStatus
##          <int>   <int> <int>            <int>         <int>
## 1            0       0   331                0             0
## # ... with 223 more variables: LearningDataScience <int>, CodeWriter
## #   <int>, CareerSwitcher <int>, CurrentJobTitleSelect <int>, TitleFit
## #   <int>, CurrentEmployerType <int>, MLToolNextYearSelect <int>,
## #   MLMethodNextYearSelect <int>, LanguageRecommendationSelect <int>,
## #   PublicDatasetsSelect <int>, LearningPlatformSelect <int>,
## #   LearningPlatformUsefulnessArxiv <int>, LearningPlatformUsefulnessBlogs
## #   <int>, LearningPlatformUsefulnessCollege <int>,
## #   LearningPlatformUsefulnessCompany <int>,
## #   LearningPlatformUsefulnessConferences <int>,
## #   LearningPlatformUsefulnessFriends <int>,
## #   LearningPlatformUsefulnessKaggle <int>,
## #   LearningPlatformUsefulnessNewsletters <int>,
## #   LearningPlatformUsefulnessCommunities <int>,
## #   LearningPlatformUsefulnessDocumentation <int>,
## #   LearningPlatformUsefulnessCourses <int>,
## #   LearningPlatformUsefulnessProjects <int>,
## #   LearningPlatformUsefulnessPodcasts <int>, LearningPlatformUsefulnessSO
## #   <int>, LearningPlatformUsefulnessTextbook <int>,
## #   LearningPlatformUsefulnessTradeBook <int>,
## #   LearningPlatformUsefulnessTutoring <int>,
## #   LearningPlatformUsefulnessYouTube <int>,
## #   BlogsPodcastsNewslettersSelect <int>, LearningDataScienceTime <int>,
## #   JobSkillImportanceBigData <int>, JobSkillImportanceDegree <int>,
## #   JobSkillImportanceStats <int>, JobSkillImportanceEnterpriseTools
## #   <int>, JobSkillImportancePython <int>, JobSkillImportanceR <int>,
## #   JobSkillImportanceSQL <int>, JobSkillImportanceKaggleRanking <int>,
## #   JobSkillImportanceMOOC <int>, JobSkillImportanceVisualizations <int>,
## #   JobSkillImportanceOtherSelect1 <int>, JobSkillImportanceOtherSelect2
## #   <int>, JobSkillImportanceOtherSelect3 <int>, CoursePlatformSelect
## #   <int>, HardwarePersonalProjectsSelect <int>, TimeSpentStudying <int>,
## #   ProveKnowledgeSelect <int>, DataScienceIdentitySelect <int>,
## #   FormalEducation <int>, MajorSelect <int>, Tenure <int>,
## #   PastJobTitlesSelect <int>, FirstTrainingSelect <int>,
## #   LearningCategorySelftTaught <int>, LearningCategoryOnlineCourses
## #   <int>, LearningCategoryWork <int>, LearningCategoryUniversity <int>,
## #   LearningCategoryKaggle <int>, LearningCategoryOther <int>,
## #   MLSkillsSelect <int>, MLTechniquesSelect <int>, ParentsEducation
## #   <int>, EmployerIndustry <int>, EmployerSize <int>, EmployerSizeChange
## #   <int>, EmployerMLTime <int>, EmployerSearchMethod <int>,
## #   UniversityImportance <int>, JobFunctionSelect <int>,
## #   WorkHardwareSelect <int>, WorkDataTypeSelect <int>,
## #   WorkProductionFrequency <int>, WorkDatasetSize <int>,
## #   WorkAlgorithmsSelect <int>, WorkToolsSelect <int>,
## #   WorkToolsFrequencyAmazonML <int>, WorkToolsFrequencyAWS <int>,
## #   WorkToolsFrequencyAngoss <int>, WorkToolsFrequencyC <int>,
## #   WorkToolsFrequencyCloudera <int>, WorkToolsFrequencyDataRobot <int>,
## #   WorkToolsFrequencyFlume <int>, WorkToolsFrequencyGCP <int>,
## #   WorkToolsFrequencyHadoop <int>, WorkToolsFrequencyIBMCognos <int>,
## #   WorkToolsFrequencyIBMSPSSModeler <int>,
## #   WorkToolsFrequencyIBMSPSSStatistics <int>, WorkToolsFrequencyIBMWatson
## #   <int>, WorkToolsFrequencyImpala <int>, WorkToolsFrequencyJava <int>,
## #   WorkToolsFrequencyJulia <int>, WorkToolsFrequencyJupyter <int>,
## #   WorkToolsFrequencyKNIMECommercial <int>, WorkToolsFrequencyKNIMEFree
## #   <int>, WorkToolsFrequencyMathematica <int>, WorkToolsFrequencyMATLAB
## #   <int>, WorkToolsFrequencyAzure <int>, WorkToolsFrequencyExcel <int>,
## #   WorkToolsFrequencyMicrosoftRServer <int>, …
```

Wow that's lucky! So many variables that don't have NAs. But ... is it too good to be true? Let's look at the entries of 


```r
multiple_choice_responses_base %>%
  dplyr::count(StudentStatus)
```

```
## # A tibble: 3 x 2
##   StudentStatus     n
##   <fct>         <int>
## 1 ""            15436
## 2 No              299
## 3 Yes             981
```

Yep. We see here we have a lot of `""` entries instead of NAs. We can correct this with `dplyr::na_if`. We can also use `%<>%`, which is a reassignment pipe. 


```r
multiple_choice_responses_base %<>%
  dplyr::na_if("")

## is the same as: 

multiple_choice_responses_base <- multiple_choice_responses_base %>%
  na_if("")
```

Now we can count the NAs again. 

```r
multiple_choice_responses_base %>%
  purrr::map_df(~sum(is.na(.)))
```

```
## # A tibble: 1 x 228
##   GenderSelect Country   Age EmploymentStatus StudentStatus
##          <int>   <int> <int>            <int>         <int>
## 1           95     121   331                0         15436
## # ... with 223 more variables: LearningDataScience <int>, CodeWriter
## #   <int>, CareerSwitcher <int>, CurrentJobTitleSelect <int>, TitleFit
## #   <int>, CurrentEmployerType <int>, MLToolNextYearSelect <int>,
## #   MLMethodNextYearSelect <int>, LanguageRecommendationSelect <int>,
## #   PublicDatasetsSelect <int>, LearningPlatformSelect <int>,
## #   LearningPlatformUsefulnessArxiv <int>, LearningPlatformUsefulnessBlogs
## #   <int>, LearningPlatformUsefulnessCollege <int>,
## #   LearningPlatformUsefulnessCompany <int>,
## #   LearningPlatformUsefulnessConferences <int>,
## #   LearningPlatformUsefulnessFriends <int>,
## #   LearningPlatformUsefulnessKaggle <int>,
## #   LearningPlatformUsefulnessNewsletters <int>,
## #   LearningPlatformUsefulnessCommunities <int>,
## #   LearningPlatformUsefulnessDocumentation <int>,
## #   LearningPlatformUsefulnessCourses <int>,
## #   LearningPlatformUsefulnessProjects <int>,
## #   LearningPlatformUsefulnessPodcasts <int>, LearningPlatformUsefulnessSO
## #   <int>, LearningPlatformUsefulnessTextbook <int>,
## #   LearningPlatformUsefulnessTradeBook <int>,
## #   LearningPlatformUsefulnessTutoring <int>,
## #   LearningPlatformUsefulnessYouTube <int>,
## #   BlogsPodcastsNewslettersSelect <int>, LearningDataScienceTime <int>,
## #   JobSkillImportanceBigData <int>, JobSkillImportanceDegree <int>,
## #   JobSkillImportanceStats <int>, JobSkillImportanceEnterpriseTools
## #   <int>, JobSkillImportancePython <int>, JobSkillImportanceR <int>,
## #   JobSkillImportanceSQL <int>, JobSkillImportanceKaggleRanking <int>,
## #   JobSkillImportanceMOOC <int>, JobSkillImportanceVisualizations <int>,
## #   JobSkillImportanceOtherSelect1 <int>, JobSkillImportanceOtherSelect2
## #   <int>, JobSkillImportanceOtherSelect3 <int>, CoursePlatformSelect
## #   <int>, HardwarePersonalProjectsSelect <int>, TimeSpentStudying <int>,
## #   ProveKnowledgeSelect <int>, DataScienceIdentitySelect <int>,
## #   FormalEducation <int>, MajorSelect <int>, Tenure <int>,
## #   PastJobTitlesSelect <int>, FirstTrainingSelect <int>,
## #   LearningCategorySelftTaught <int>, LearningCategoryOnlineCourses
## #   <int>, LearningCategoryWork <int>, LearningCategoryUniversity <int>,
## #   LearningCategoryKaggle <int>, LearningCategoryOther <int>,
## #   MLSkillsSelect <int>, MLTechniquesSelect <int>, ParentsEducation
## #   <int>, EmployerIndustry <int>, EmployerSize <int>, EmployerSizeChange
## #   <int>, EmployerMLTime <int>, EmployerSearchMethod <int>,
## #   UniversityImportance <int>, JobFunctionSelect <int>,
## #   WorkHardwareSelect <int>, WorkDataTypeSelect <int>,
## #   WorkProductionFrequency <int>, WorkDatasetSize <int>,
## #   WorkAlgorithmsSelect <int>, WorkToolsSelect <int>,
## #   WorkToolsFrequencyAmazonML <int>, WorkToolsFrequencyAWS <int>,
## #   WorkToolsFrequencyAngoss <int>, WorkToolsFrequencyC <int>,
## #   WorkToolsFrequencyCloudera <int>, WorkToolsFrequencyDataRobot <int>,
## #   WorkToolsFrequencyFlume <int>, WorkToolsFrequencyGCP <int>,
## #   WorkToolsFrequencyHadoop <int>, WorkToolsFrequencyIBMCognos <int>,
## #   WorkToolsFrequencyIBMSPSSModeler <int>,
## #   WorkToolsFrequencyIBMSPSSStatistics <int>, WorkToolsFrequencyIBMWatson
## #   <int>, WorkToolsFrequencyImpala <int>, WorkToolsFrequencyJava <int>,
## #   WorkToolsFrequencyJulia <int>, WorkToolsFrequencyJupyter <int>,
## #   WorkToolsFrequencyKNIMECommercial <int>, WorkToolsFrequencyKNIMEFree
## #   <int>, WorkToolsFrequencyMathematica <int>, WorkToolsFrequencyMATLAB
## #   <int>, WorkToolsFrequencyAzure <int>, WorkToolsFrequencyExcel <int>,
## #   WorkToolsFrequencyMicrosoftRServer <int>, …
```

And it's fixed! 

Alternative: use `readr::read_csv` instead of `read.csv`. 


```r
multiple_choice_responses <- readr::read_csv("multipleChoiceResponses.csv")
```

```
## Parsed with column specification:
## cols(
##   .default = col_character(),
##   Age = col_double(),
##   LearningCategorySelftTaught = col_double(),
##   LearningCategoryOnlineCourses = col_double(),
##   LearningCategoryWork = col_double(),
##   LearningCategoryUniversity = col_double(),
##   LearningCategoryKaggle = col_double(),
##   LearningCategoryOther = col_double(),
##   WorkToolsFrequencyKNIMECommercial = col_logical(),
##   TimeGatheringData = col_double(),
##   TimeModelBuilding = col_double(),
##   TimeProduction = col_double(),
##   TimeVisualizing = col_double(),
##   TimeFindingInsights = col_double(),
##   TimeOtherSelect = col_double(),
##   CompensationAmount = col_number()
## )
```

```
## See spec(...) for full column specifications.
```

```
## Warning: 43 parsing failures.
##  row                               col           expected           actual                          file
## 1209 CompensationAmount                a number           -                'multipleChoiceResponses.csv'
## 1316 WorkToolsFrequencyKNIMECommercial 1/0/T/F/TRUE/FALSE Rarely           'multipleChoiceResponses.csv'
## 1594 WorkToolsFrequencyKNIMECommercial 1/0/T/F/TRUE/FALSE Often            'multipleChoiceResponses.csv'
## 2443 WorkToolsFrequencyKNIMECommercial 1/0/T/F/TRUE/FALSE Most of the time 'multipleChoiceResponses.csv'
## 2466 WorkToolsFrequencyKNIMECommercial 1/0/T/F/TRUE/FALSE Most of the time 'multipleChoiceResponses.csv'
## .... ................................. .................. ................ .............................
## See problems(...) for more details.
```

It's definitely faster, but it seems we have some errors. Let's inspect them. 


```r
problems(multiple_choice_responses)
```

```
## # A tibble: 43 x 5
##      row col                               expected           actual file 
##    <int> <chr>                             <chr>              <chr>  <chr>
##  1  1209 CompensationAmount                a number           -      'mul…
##  2  1316 WorkToolsFrequencyKNIMECommercial 1/0/T/F/TRUE/FALSE Rarely 'mul…
##  3  1594 WorkToolsFrequencyKNIMECommercial 1/0/T/F/TRUE/FALSE Often  'mul…
##  4  2443 WorkToolsFrequencyKNIMECommercial 1/0/T/F/TRUE/FALSE Most … 'mul…
##  5  2466 WorkToolsFrequencyKNIMECommercial 1/0/T/F/TRUE/FALSE Most … 'mul…
##  6  2622 WorkToolsFrequencyKNIMECommercial 1/0/T/F/TRUE/FALSE Often  'mul…
##  7  2630 WorkToolsFrequencyKNIMECommercial 1/0/T/F/TRUE/FALSE Somet… 'mul…
##  8  2724 WorkToolsFrequencyKNIMECommercial 1/0/T/F/TRUE/FALSE Often  'mul…
##  9  3022 WorkToolsFrequencyKNIMECommercial 1/0/T/F/TRUE/FALSE Somet… 'mul…
## 10  3396 WorkToolsFrequencyKNIMECommercial 1/0/T/F/TRUE/FALSE Somet… 'mul…
## # ... with 33 more rows
```

We see the row and column where the problem occurs. What's happening is that `read_csv` uses the first 1000 rows of a column to guess its type. But in some cases, it's guessing the column integer, because the first 1000 rows are whole numbers, when actually it should be double, as some entries have decimal points. We can fix this by changing the number of rows `read_csv` uses to guess the column type (with the `guess_max` argument) to the number of rows in the dataset. 


```r
multiple_choice_responses <- readr::read_csv("multipleChoiceResponses.csv", 
                                             guess_max = nrow(multiple_choice_responses))
```

```
## Parsed with column specification:
## cols(
##   .default = col_character(),
##   Age = col_double(),
##   LearningCategorySelftTaught = col_double(),
##   LearningCategoryOnlineCourses = col_double(),
##   LearningCategoryWork = col_double(),
##   LearningCategoryUniversity = col_double(),
##   LearningCategoryKaggle = col_double(),
##   LearningCategoryOther = col_double(),
##   TimeGatheringData = col_double(),
##   TimeModelBuilding = col_double(),
##   TimeProduction = col_double(),
##   TimeVisualizing = col_double(),
##   TimeFindingInsights = col_double(),
##   TimeOtherSelect = col_double()
## )
```

```
## See spec(...) for full column specifications.
```

Great! Let's see what we can glean from the column names themselves.


```r
colnames(multiple_choice_responses)
```

```
##   [1] "GenderSelect"                               
##   [2] "Country"                                    
##   [3] "Age"                                        
##   [4] "EmploymentStatus"                           
##   [5] "StudentStatus"                              
##   [6] "LearningDataScience"                        
##   [7] "CodeWriter"                                 
##   [8] "CareerSwitcher"                             
##   [9] "CurrentJobTitleSelect"                      
##  [10] "TitleFit"                                   
##  [11] "CurrentEmployerType"                        
##  [12] "MLToolNextYearSelect"                       
##  [13] "MLMethodNextYearSelect"                     
##  [14] "LanguageRecommendationSelect"               
##  [15] "PublicDatasetsSelect"                       
##  [16] "LearningPlatformSelect"                     
##  [17] "LearningPlatformUsefulnessArxiv"            
##  [18] "LearningPlatformUsefulnessBlogs"            
##  [19] "LearningPlatformUsefulnessCollege"          
##  [20] "LearningPlatformUsefulnessCompany"          
##  [21] "LearningPlatformUsefulnessConferences"      
##  [22] "LearningPlatformUsefulnessFriends"          
##  [23] "LearningPlatformUsefulnessKaggle"           
##  [24] "LearningPlatformUsefulnessNewsletters"      
##  [25] "LearningPlatformUsefulnessCommunities"      
##  [26] "LearningPlatformUsefulnessDocumentation"    
##  [27] "LearningPlatformUsefulnessCourses"          
##  [28] "LearningPlatformUsefulnessProjects"         
##  [29] "LearningPlatformUsefulnessPodcasts"         
##  [30] "LearningPlatformUsefulnessSO"               
##  [31] "LearningPlatformUsefulnessTextbook"         
##  [32] "LearningPlatformUsefulnessTradeBook"        
##  [33] "LearningPlatformUsefulnessTutoring"         
##  [34] "LearningPlatformUsefulnessYouTube"          
##  [35] "BlogsPodcastsNewslettersSelect"             
##  [36] "LearningDataScienceTime"                    
##  [37] "JobSkillImportanceBigData"                  
##  [38] "JobSkillImportanceDegree"                   
##  [39] "JobSkillImportanceStats"                    
##  [40] "JobSkillImportanceEnterpriseTools"          
##  [41] "JobSkillImportancePython"                   
##  [42] "JobSkillImportanceR"                        
##  [43] "JobSkillImportanceSQL"                      
##  [44] "JobSkillImportanceKaggleRanking"            
##  [45] "JobSkillImportanceMOOC"                     
##  [46] "JobSkillImportanceVisualizations"           
##  [47] "JobSkillImportanceOtherSelect1"             
##  [48] "JobSkillImportanceOtherSelect2"             
##  [49] "JobSkillImportanceOtherSelect3"             
##  [50] "CoursePlatformSelect"                       
##  [51] "HardwarePersonalProjectsSelect"             
##  [52] "TimeSpentStudying"                          
##  [53] "ProveKnowledgeSelect"                       
##  [54] "DataScienceIdentitySelect"                  
##  [55] "FormalEducation"                            
##  [56] "MajorSelect"                                
##  [57] "Tenure"                                     
##  [58] "PastJobTitlesSelect"                        
##  [59] "FirstTrainingSelect"                        
##  [60] "LearningCategorySelftTaught"                
##  [61] "LearningCategoryOnlineCourses"              
##  [62] "LearningCategoryWork"                       
##  [63] "LearningCategoryUniversity"                 
##  [64] "LearningCategoryKaggle"                     
##  [65] "LearningCategoryOther"                      
##  [66] "MLSkillsSelect"                             
##  [67] "MLTechniquesSelect"                         
##  [68] "ParentsEducation"                           
##  [69] "EmployerIndustry"                           
##  [70] "EmployerSize"                               
##  [71] "EmployerSizeChange"                         
##  [72] "EmployerMLTime"                             
##  [73] "EmployerSearchMethod"                       
##  [74] "UniversityImportance"                       
##  [75] "JobFunctionSelect"                          
##  [76] "WorkHardwareSelect"                         
##  [77] "WorkDataTypeSelect"                         
##  [78] "WorkProductionFrequency"                    
##  [79] "WorkDatasetSize"                            
##  [80] "WorkAlgorithmsSelect"                       
##  [81] "WorkToolsSelect"                            
##  [82] "WorkToolsFrequencyAmazonML"                 
##  [83] "WorkToolsFrequencyAWS"                      
##  [84] "WorkToolsFrequencyAngoss"                   
##  [85] "WorkToolsFrequencyC"                        
##  [86] "WorkToolsFrequencyCloudera"                 
##  [87] "WorkToolsFrequencyDataRobot"                
##  [88] "WorkToolsFrequencyFlume"                    
##  [89] "WorkToolsFrequencyGCP"                      
##  [90] "WorkToolsFrequencyHadoop"                   
##  [91] "WorkToolsFrequencyIBMCognos"                
##  [92] "WorkToolsFrequencyIBMSPSSModeler"           
##  [93] "WorkToolsFrequencyIBMSPSSStatistics"        
##  [94] "WorkToolsFrequencyIBMWatson"                
##  [95] "WorkToolsFrequencyImpala"                   
##  [96] "WorkToolsFrequencyJava"                     
##  [97] "WorkToolsFrequencyJulia"                    
##  [98] "WorkToolsFrequencyJupyter"                  
##  [99] "WorkToolsFrequencyKNIMECommercial"          
## [100] "WorkToolsFrequencyKNIMEFree"                
## [101] "WorkToolsFrequencyMathematica"              
## [102] "WorkToolsFrequencyMATLAB"                   
## [103] "WorkToolsFrequencyAzure"                    
## [104] "WorkToolsFrequencyExcel"                    
## [105] "WorkToolsFrequencyMicrosoftRServer"         
## [106] "WorkToolsFrequencyMicrosoftSQL"             
## [107] "WorkToolsFrequencyMinitab"                  
## [108] "WorkToolsFrequencyNoSQL"                    
## [109] "WorkToolsFrequencyOracle"                   
## [110] "WorkToolsFrequencyOrange"                   
## [111] "WorkToolsFrequencyPerl"                     
## [112] "WorkToolsFrequencyPython"                   
## [113] "WorkToolsFrequencyQlik"                     
## [114] "WorkToolsFrequencyR"                        
## [115] "WorkToolsFrequencyRapidMinerCommercial"     
## [116] "WorkToolsFrequencyRapidMinerFree"           
## [117] "WorkToolsFrequencySalfrod"                  
## [118] "WorkToolsFrequencySAPBusinessObjects"       
## [119] "WorkToolsFrequencySASBase"                  
## [120] "WorkToolsFrequencySASEnterprise"            
## [121] "WorkToolsFrequencySASJMP"                   
## [122] "WorkToolsFrequencySpark"                    
## [123] "WorkToolsFrequencySQL"                      
## [124] "WorkToolsFrequencyStan"                     
## [125] "WorkToolsFrequencyStatistica"               
## [126] "WorkToolsFrequencyTableau"                  
## [127] "WorkToolsFrequencyTensorFlow"               
## [128] "WorkToolsFrequencyTIBCO"                    
## [129] "WorkToolsFrequencyUnix"                     
## [130] "WorkToolsFrequencySelect1"                  
## [131] "WorkToolsFrequencySelect2"                  
## [132] "WorkFrequencySelect3"                       
## [133] "WorkMethodsSelect"                          
## [134] "WorkMethodsFrequencyA/B"                    
## [135] "WorkMethodsFrequencyAssociationRules"       
## [136] "WorkMethodsFrequencyBayesian"               
## [137] "WorkMethodsFrequencyCNNs"                   
## [138] "WorkMethodsFrequencyCollaborativeFiltering" 
## [139] "WorkMethodsFrequencyCross-Validation"       
## [140] "WorkMethodsFrequencyDataVisualization"      
## [141] "WorkMethodsFrequencyDecisionTrees"          
## [142] "WorkMethodsFrequencyEnsembleMethods"        
## [143] "WorkMethodsFrequencyEvolutionaryApproaches" 
## [144] "WorkMethodsFrequencyGANs"                   
## [145] "WorkMethodsFrequencyGBM"                    
## [146] "WorkMethodsFrequencyHMMs"                   
## [147] "WorkMethodsFrequencyKNN"                    
## [148] "WorkMethodsFrequencyLiftAnalysis"           
## [149] "WorkMethodsFrequencyLogisticRegression"     
## [150] "WorkMethodsFrequencyMLN"                    
## [151] "WorkMethodsFrequencyNaiveBayes"             
## [152] "WorkMethodsFrequencyNLP"                    
## [153] "WorkMethodsFrequencyNeuralNetworks"         
## [154] "WorkMethodsFrequencyPCA"                    
## [155] "WorkMethodsFrequencyPrescriptiveModeling"   
## [156] "WorkMethodsFrequencyRandomForests"          
## [157] "WorkMethodsFrequencyRecommenderSystems"     
## [158] "WorkMethodsFrequencyRNNs"                   
## [159] "WorkMethodsFrequencySegmentation"           
## [160] "WorkMethodsFrequencySimulation"             
## [161] "WorkMethodsFrequencySVMs"                   
## [162] "WorkMethodsFrequencyTextAnalysis"           
## [163] "WorkMethodsFrequencyTimeSeriesAnalysis"     
## [164] "WorkMethodsFrequencySelect1"                
## [165] "WorkMethodsFrequencySelect2"                
## [166] "WorkMethodsFrequencySelect3"                
## [167] "TimeGatheringData"                          
## [168] "TimeModelBuilding"                          
## [169] "TimeProduction"                             
## [170] "TimeVisualizing"                            
## [171] "TimeFindingInsights"                        
## [172] "TimeOtherSelect"                            
## [173] "AlgorithmUnderstandingLevel"                
## [174] "WorkChallengesSelect"                       
## [175] "WorkChallengeFrequencyPolitics"             
## [176] "WorkChallengeFrequencyUnusedResults"        
## [177] "WorkChallengeFrequencyUnusefulInstrumenting"
## [178] "WorkChallengeFrequencyDeployment"           
## [179] "WorkChallengeFrequencyDirtyData"            
## [180] "WorkChallengeFrequencyExplaining"           
## [181] "WorkChallengeFrequencyPass"                 
## [182] "WorkChallengeFrequencyIntegration"          
## [183] "WorkChallengeFrequencyTalent"               
## [184] "WorkChallengeFrequencyDataFunds"            
## [185] "WorkChallengeFrequencyDomainExpertise"      
## [186] "WorkChallengeFrequencyML"                   
## [187] "WorkChallengeFrequencyTools"                
## [188] "WorkChallengeFrequencyExpectations"         
## [189] "WorkChallengeFrequencyITCoordination"       
## [190] "WorkChallengeFrequencyHiringFunds"          
## [191] "WorkChallengeFrequencyPrivacy"              
## [192] "WorkChallengeFrequencyScaling"              
## [193] "WorkChallengeFrequencyEnvironments"         
## [194] "WorkChallengeFrequencyClarity"              
## [195] "WorkChallengeFrequencyDataAccess"           
## [196] "WorkChallengeFrequencyOtherSelect"          
## [197] "WorkDataVisualizations"                     
## [198] "WorkInternalVsExternalTools"                
## [199] "WorkMLTeamSeatSelect"                       
## [200] "WorkDatasets"                               
## [201] "WorkDatasetsChallenge"                      
## [202] "WorkDataStorage"                            
## [203] "WorkDataSharing"                            
## [204] "WorkDataSourcing"                           
## [205] "WorkCodeSharing"                            
## [206] "RemoteWork"                                 
## [207] "CompensationAmount"                         
## [208] "CompensationCurrency"                       
## [209] "SalaryChange"                               
## [210] "JobSatisfaction"                            
## [211] "JobSearchResource"                          
## [212] "JobHuntTime"                                
## [213] "JobFactorLearning"                          
## [214] "JobFactorSalary"                            
## [215] "JobFactorOffice"                            
## [216] "JobFactorLanguages"                         
## [217] "JobFactorCommute"                           
## [218] "JobFactorManagement"                        
## [219] "JobFactorExperienceLevel"                   
## [220] "JobFactorDepartment"                        
## [221] "JobFactorTitle"                             
## [222] "JobFactorCompanyFunding"                    
## [223] "JobFactorImpact"                            
## [224] "JobFactorRemote"                            
## [225] "JobFactorIndustry"                          
## [226] "JobFactorLeaderReputation"                  
## [227] "JobFactorDiversity"                         
## [228] "JobFactorPublishingOpportunity"
```

It's clear that there were categories of questions, like "Job Factor" and "Work Methods Frequency."

Now let's take a look at our numeric columns with skimr. Skimr is a package from rOpenSci that allows you to quickly view summaries of your data. `select_if` is a great package if you want to select only columns where a certain condition is true (in this case, whether it's a numeric column).  


```r
multiple_choice_responses %>%
  select_if(is.numeric) %>%
  skimr::skim()
```

```
## Skim summary statistics
##  n obs: 16716 
##  n variables: 13 
## 
## Variable type: numeric 
##                       variable missing complete     n  mean    sd p0 p25
##                            Age     331    16385 16716 32.37 10.47  0  25
##         LearningCategoryKaggle    3590    13126 16716  5.53 11.07  0   0
##  LearningCategoryOnlineCourses    3590    13126 16716 27.38 26.86  0   5
##          LearningCategoryOther    3622    13094 16716  1.8   9.36  0   0
##    LearningCategorySelftTaught    3607    13109 16716 33.37 25.79  0  15
##     LearningCategoryUniversity    3594    13122 16716 16.99 23.68  0   0
##           LearningCategoryWork    3605    13111 16716 15.22 19     0   0
##            TimeFindingInsights    9193     7523 16716 13.09 12.97  0   5
##              TimeGatheringData    9186     7530 16716 36.14 21.65  0  20
##              TimeModelBuilding    9188     7528 16716 21.27 16.17  0  10
##                TimeOtherSelect    9203     7513 16716  2.4  12.16  0   0
##                 TimeProduction    9199     7517 16716 10.81 12.26  0   0
##                TimeVisualizing    9187     7529 16716 13.87 11.72  0   5
##  median p75 p100     hist
##      30  37  100 ▁▅▇▃▁▁▁▁
##       0  10  100 ▇▁▁▁▁▁▁▁
##      20  40  100 ▇▃▂▃▁▁▁▁
##       0   0  100 ▇▁▁▁▁▁▁▁
##      30  50  100 ▇▇▅▇▂▁▁▂
##       5  30  100 ▇▂▁▁▁▁▁▁
##      10  25  100 ▇▂▁▁▁▁▁▁
##      10  20  303 ▇▁▁▁▁▁▁▁
##      35  50  100 ▅▅▅▇▂▂▁▁
##      20  30  100 ▇▇▃▂▁▁▁▁
##       0   0  100 ▇▁▁▁▁▁▁▁
##      10  15  100 ▇▂▁▁▁▁▁▁
##      10  20  100 ▇▅▁▁▁▁▁▁
```

I love the histograms. We can quickly see from the histogram that people learn a lot from being self taught and spend a good amount of time building models and gathering data, compared to visualizing or working in production.   

Let's see how many distinct answers we have for each question (most interesting for the non-numeric questions). `n_distinct()` is just a shorter and faster version of `length(unique())`. We can use `map_df` once again to apply a function to every column. 


```r
multiple_choice_responses %>%
  purrr::map_df(~n_distinct(.)) 
```

```
## # A tibble: 1 x 228
##   GenderSelect Country   Age EmploymentStatus StudentStatus
##          <int>   <int> <int>            <int>         <int>
## 1            5      53    85                7             3
## # ... with 223 more variables: LearningDataScience <int>, CodeWriter
## #   <int>, CareerSwitcher <int>, CurrentJobTitleSelect <int>, TitleFit
## #   <int>, CurrentEmployerType <int>, MLToolNextYearSelect <int>,
## #   MLMethodNextYearSelect <int>, LanguageRecommendationSelect <int>,
## #   PublicDatasetsSelect <int>, LearningPlatformSelect <int>,
## #   LearningPlatformUsefulnessArxiv <int>, LearningPlatformUsefulnessBlogs
## #   <int>, LearningPlatformUsefulnessCollege <int>,
## #   LearningPlatformUsefulnessCompany <int>,
## #   LearningPlatformUsefulnessConferences <int>,
## #   LearningPlatformUsefulnessFriends <int>,
## #   LearningPlatformUsefulnessKaggle <int>,
## #   LearningPlatformUsefulnessNewsletters <int>,
## #   LearningPlatformUsefulnessCommunities <int>,
## #   LearningPlatformUsefulnessDocumentation <int>,
## #   LearningPlatformUsefulnessCourses <int>,
## #   LearningPlatformUsefulnessProjects <int>,
## #   LearningPlatformUsefulnessPodcasts <int>, LearningPlatformUsefulnessSO
## #   <int>, LearningPlatformUsefulnessTextbook <int>,
## #   LearningPlatformUsefulnessTradeBook <int>,
## #   LearningPlatformUsefulnessTutoring <int>,
## #   LearningPlatformUsefulnessYouTube <int>,
## #   BlogsPodcastsNewslettersSelect <int>, LearningDataScienceTime <int>,
## #   JobSkillImportanceBigData <int>, JobSkillImportanceDegree <int>,
## #   JobSkillImportanceStats <int>, JobSkillImportanceEnterpriseTools
## #   <int>, JobSkillImportancePython <int>, JobSkillImportanceR <int>,
## #   JobSkillImportanceSQL <int>, JobSkillImportanceKaggleRanking <int>,
## #   JobSkillImportanceMOOC <int>, JobSkillImportanceVisualizations <int>,
## #   JobSkillImportanceOtherSelect1 <int>, JobSkillImportanceOtherSelect2
## #   <int>, JobSkillImportanceOtherSelect3 <int>, CoursePlatformSelect
## #   <int>, HardwarePersonalProjectsSelect <int>, TimeSpentStudying <int>,
## #   ProveKnowledgeSelect <int>, DataScienceIdentitySelect <int>,
## #   FormalEducation <int>, MajorSelect <int>, Tenure <int>,
## #   PastJobTitlesSelect <int>, FirstTrainingSelect <int>,
## #   LearningCategorySelftTaught <int>, LearningCategoryOnlineCourses
## #   <int>, LearningCategoryWork <int>, LearningCategoryUniversity <int>,
## #   LearningCategoryKaggle <int>, LearningCategoryOther <int>,
## #   MLSkillsSelect <int>, MLTechniquesSelect <int>, ParentsEducation
## #   <int>, EmployerIndustry <int>, EmployerSize <int>, EmployerSizeChange
## #   <int>, EmployerMLTime <int>, EmployerSearchMethod <int>,
## #   UniversityImportance <int>, JobFunctionSelect <int>,
## #   WorkHardwareSelect <int>, WorkDataTypeSelect <int>,
## #   WorkProductionFrequency <int>, WorkDatasetSize <int>,
## #   WorkAlgorithmsSelect <int>, WorkToolsSelect <int>,
## #   WorkToolsFrequencyAmazonML <int>, WorkToolsFrequencyAWS <int>,
## #   WorkToolsFrequencyAngoss <int>, WorkToolsFrequencyC <int>,
## #   WorkToolsFrequencyCloudera <int>, WorkToolsFrequencyDataRobot <int>,
## #   WorkToolsFrequencyFlume <int>, WorkToolsFrequencyGCP <int>,
## #   WorkToolsFrequencyHadoop <int>, WorkToolsFrequencyIBMCognos <int>,
## #   WorkToolsFrequencyIBMSPSSModeler <int>,
## #   WorkToolsFrequencyIBMSPSSStatistics <int>, WorkToolsFrequencyIBMWatson
## #   <int>, WorkToolsFrequencyImpala <int>, WorkToolsFrequencyJava <int>,
## #   WorkToolsFrequencyJulia <int>, WorkToolsFrequencyJupyter <int>,
## #   WorkToolsFrequencyKNIMECommercial <int>, WorkToolsFrequencyKNIMEFree
## #   <int>, WorkToolsFrequencyMathematica <int>, WorkToolsFrequencyMATLAB
## #   <int>, WorkToolsFrequencyAzure <int>, WorkToolsFrequencyExcel <int>,
## #   WorkToolsFrequencyMicrosoftRServer <int>, …
```

This data would be more helpful if it was tidy and had two columns, `variable` and `num_distinct_answers`. We can use `tidyr::gather` to change our data from "wide" to "long" format and then `arrange` it so we can see the columns with the most distinct answers first. If you've used (or are still using!) reshape2, check out tidyr; reshape2 is retired. While not exactly equivalent, `tidyr::spread` replaces `reshape2::dcast`, `tidyr::separate` `reshape2::colsplit`, and `tidyr::gather` `reshape2::melt`. 


```r
multiple_choice_responses %>%
  purrr::map_df(~n_distinct(.)) %>%
  tidyr::gather(question, num_distinct_answers) %>%
  arrange(desc(num_distinct_answers))
```

```
## # A tibble: 228 x 2
##    question               num_distinct_answers
##    <chr>                                 <int>
##  1 WorkMethodsSelect                      6191
##  2 LearningPlatformSelect                 5363
##  3 WorkToolsSelect                        5249
##  4 WorkChallengesSelect                   4288
##  5 WorkDatasetsChallenge                  2221
##  6 PastJobTitlesSelect                    1856
##  7 MLTechniquesSelect                     1802
##  8 WorkDatasets                           1724
##  9 WorkAlgorithmsSelect                   1421
## 10 MLSkillsSelect                         1038
## # ... with 218 more rows
```

Let's take a look at one of the ones with the most distinct answers. 


```r
multiple_choice_responses %>%
  count(fct_infreq(WorkMethodsSelect))
```

```
## # A tibble: 6,191 x 2
##    `fct_infreq(WorkMethodsSelect)`             n
##    <fct>                                   <int>
##  1 Data Visualization                        144
##  2 Other                                     144
##  3 Logistic Regression                        66
##  4 Time Series Analysis                       49
##  5 Neural Networks                            45
##  6 A/B Testing                                42
##  7 Data Visualization,Time Series Analysis    37
##  8 Text Analytics                             36
##  9 Decision Trees                             29
## 10 CNNs                                       22
## # ... with 6,181 more rows
```

This is clearly multiple select situation, where if a person selected multiple answers they're listed separated by commas. Let's tidy it up. 

`!` here is short for `== FALSE`. So `!is.na(WorkMethodsSelect)` is the same as `is.na(WorkMethodsSelect) == FALSE`. 


```r
nested_workmethods <- multiple_choice_responses %>%
  select(WorkMethodsSelect) %>%
  filter(!is.na(WorkMethodsSelect)) %>%
  mutate(work_method = str_split(WorkMethodsSelect, ",")) 

nested_workmethods
```

```
## # A tibble: 7,773 x 2
##    WorkMethodsSelect                                           work_method
##    <chr>                                                       <list>     
##  1 Association Rules,Collaborative Filtering,Neural Networks,… <chr [5]>  
##  2 A/B Testing,Bayesian Techniques,Data Visualization,Decisio… <chr [12]> 
##  3 Association Rules,Bayesian Techniques,CNNs,Collaborative F… <chr [17]> 
##  4 Association Rules,Bayesian Techniques,CNNs,Cross-Validatio… <chr [14]> 
##  5 A/B Testing,Cross-Validation,Data Visualization,Decision T… <chr [12]> 
##  6 Data Visualization                                          <chr [1]>  
##  7 A/B Testing,Association Rules,CNNs,Cross-Validation,Data V… <chr [14]> 
##  8 Bayesian Techniques,Collaborative Filtering,Data Visualiza… <chr [12]> 
##  9 Cross-Validation,Data Visualization,Decision Trees,Ensembl… <chr [7]>  
## 10 A/B Testing,Bayesian Techniques,Decision Trees,Naive Bayes… <chr [5]>  
## # ... with 7,763 more rows
```

We can unnest. 


```r
unnested_workmethods <- nested_workmethods %>%
  unnest(work_method) %>%
  select(work_method)

unnested_workmethods
```

```
## # A tibble: 59,497 x 1
##    work_method                     
##    <chr>                           
##  1 Association Rules               
##  2 Collaborative Filtering         
##  3 Neural Networks                 
##  4 PCA and Dimensionality Reduction
##  5 Random Forests                  
##  6 A/B Testing                     
##  7 Bayesian Techniques             
##  8 Data Visualization              
##  9 Decision Trees                  
## 10 Ensemble Methods                
## # ... with 59,487 more rows
```

Now we have a couple options for examining the frequency of different work methods. But before we do so, we actually bring it back to having each method be one row and the number of people (in this case, number of entires, since each person could only list a method once) being another column. 


```r
method_freq <- unnested_workmethods %>%
  count(method = fct_infreq(work_method))

method_freq
```

```
## # A tibble: 31 x 2
##    method                               n
##    <fct>                            <int>
##  1 Data Visualization                5022
##  2 Logistic Regression               4291
##  3 Cross-Validation                  3868
##  4 Decision Trees                    3695
##  5 Random Forests                    3454
##  6 Time Series Analysis              3153
##  7 Neural Networks                   2811
##  8 PCA and Dimensionality Reduction  2789
##  9 kNN and Other Clustering          2624
## 10 Text Analytics                    2405
## # ... with 21 more rows
```

Now I want to move on to understanding what challenges people face at work. This was one of those categories where there were multiple questions asked, all having names starting with `WorkChallengeFrequency` and ending with the challenge (e.g "DirtyData"). 

We can find the relevant columns by using the dplyr `select` helper `contains`. We then use `gather` to tidy the data for analysis, keep only the non-NAs, and remove the irrelevant part of the name for each question using `stringr::str_replace`. 


```r
WorkChallenges <- multiple_choice_responses %>%
  select(contains("WorkChallengeFrequency")) %>%
  gather(question, response) %>%
  filter(!is.na(response)) %>%
  mutate(question = stringr::str_replace(question, "WorkChallengeFrequency", "")) 

ggplot(WorkChallenges, aes(x = response)) + 
  geom_bar() + 
  facet_wrap(~question) + 
  theme(axis.text.x = element_text(angle = 90, hjust = 1))
```

![](data_day_script_accompanying_files/figure-html/unnamed-chunk-17-1.png)<!-- -->

This graph has two main problems. First, there are too many histograms. But second, the order of the x-axis is wrong. We want it to go from least often to most, but instead `rarely` is in the middle. We can manually reorder the level of this variable using `forcats::fct_relevel`. 


```r
WorkChallenges %>%
  mutate(response = forcats::fct_relevel(response, "Rarely", "Sometimes", "Often", "Most of the time")) %>%
  ggplot(aes(x = response)) + 
  geom_bar() + 
  facet_wrap(~question) + 
  theme(axis.text.x = element_text(angle = 90, hjust = 1))
```

![](data_day_script_accompanying_files/figure-html/unnamed-chunk-18-1.png)<!-- -->

Now we've got the x-axis in the order we want it. Let's try dichotimizing the variable by grouping "most of the time" and "often" together as the person considering something a challenge. We can use `if_else` and `%in%`. `%in%` is equivalent to `response == "Most of the time" | response == "Often"` and can save you a lot of typing if you have a bunch of variables to match. 

Grouping by the question, we can use `summarise` to reduce the dataset to one row per question, adding the variable `perc_problem` for the percentage of responses that thought something was a challenge often or most of the time. This way, we can make one graph with data for all the questions and easily compare them. 


```r
perc_problem_work_challenge <- WorkChallenges %>%
  mutate(response = if_else(response %in% c("Most of the time", "Often"), 1, 0)) %>%
  group_by(question) %>%
  summarise(perc_problem = mean(response)) 
```


```r
ggplot(perc_problem_work_challenge, aes(x = question, y = perc_problem)) + 
  geom_point() +
  coord_flip()
```

![](data_day_script_accompanying_files/figure-html/unnamed-chunk-20-1.png)<!-- -->

This is better, but it's hard to read because the points are scattered all over the place. Although you can spot the highest one, then you have to track it back to the correct variable. And it's also hard to tell the order of the ones in the middle. 

We can use `forcats:fct_reorder` to have the x-axis be ordered by another variable, in this case the y-axis. While we're at it, we can use `scale_y_continuous` and`scales::percent` to update our axis to display in percent and `labs` to change our axis labels. 


```r
ggplot(perc_problem_work_challenge, aes(x = fct_reorder(question, perc_problem), y = perc_problem)) + 
  geom_point() +
  coord_flip() + 
  scale_y_continuous(labels = scales::percent) + 
  labs(x = "Aspect", y = "Percentage encountering challenge frequently")
```

![](data_day_script_accompanying_files/figure-html/unnamed-chunk-21-1.png)<!-- -->



