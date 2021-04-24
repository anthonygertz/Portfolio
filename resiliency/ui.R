shinyUI(
  dashboardPage(
    dashboardHeader(title = span(
      "Comparative Resiliency Across Time",
      style = 'color: white; font-size: 30px, font-weight: bold'),
      titleWidth = 400),
    
    dashboardSidebar(
      selectInput('state',
                  'Select State:',
                  choices = c("", state_choices),
                  selected = NULL),
      uiOutput('county_dynamic'),
      sidebarMenu(
        menuItem('County Summary', tabName = 'county_sum'),
        menuItem('State Summary', tabName = 'state_sum'),
        menuItem('Southern Region', tabName = 'region')
      ) #sidebarMenu Paren
      
    ), #Dashboard Slider Paren
    
    dashboardBody(
      shinyDashboardThemes(
        theme = "blue_gradient"
      ),
      tabItems(
        tabItem(tabName = 'county_sum',
                fluidRow(
                tabBox(
                    title = '',
                    tabPanel('Calculated Ratio Per Year',
                             h3(textOutput('county_selection1')),
                             p(''),
                             tableOutput('county_ratio'),
                             plotlyOutput('county_plot_ratio'),
                             plotlyOutput('county_plot')),
                    tabPanel('Per Year Summary', 
                             h3(textOutput('county_selection2')),
                             p(''),
                             tableOutput('county_sum_table'),
                             # radioButtons('damage_class1',
                             #             label = 'Select Nominal Damage Class:',
                             #             choices = list('Total Nominal Damage' = 'Total Nominal Damage', 
                             #                            'Max Nominal Damage' = 'Max Nominal Damage', 
                             #                            'Mean Nominal' = 'Mean Nominal Damage')),
                             # radioButtons('damage_class2',
                             #              label = 'Select CPI Adjusted Damage Class:',
                             #              choices = list('Total CPI Adjusted Damage' = 'Total CPI Adjusted Damage', 
                             #                             'Max CPI Adjusted Damage' = 'Max CPI Adjusted Damage', 
                             #                             'Mean CPI Adjusted Damage' = 'Mean CPI Adjusted Damage')),
                             plotlyOutput('county_plot_damage')),
                    tabPanel('County Versus State',
                             h3(textOutput('county_selection4')),
                             p(''),
                             tableOutput('county_sum_magic'),
                             h3(textOutput('state_selection4')),
                             p(''),
                             tableOutput('state_sum_table1')),
                    tabPanel('Complete List',
                             h3(textOutput('county_selection3')),
                             p(''),
                             tableOutput('county_full'))
                      ) #tabBox Paren
                      ) #fluidRow Paren
                ), #tabItem Paren
        
        tabItem(tabName = 'state_sum',
                tabBox(
                    title = '',
                    tabPanel('Statewide Summary',
                             h3(textOutput('state_selection')),
                             p(''),
                             tableOutput('state_sum_table'),
                             h3('Individual Counties'),
                             p(''),
                             tableOutput('state_county_table'),
                             plotlyOutput('state_counties')
                             ),
                    tabPanel('Calculated Ratio Per Year',
                             h3(textOutput('state_selection1')),
                             p(''),
                             tableOutput('state_ratio'),
                             plotlyOutput('state_plot_ratio')
                             ),
                    tabPanel('Per Year Summary', 
                             h3(textOutput('state_selection2')),
                             p(''),
                             tableOutput('state_sum_year')),
                    tabPanel('Complete List', 
                             h3(textOutput('state_selection3')),
                             p(''),
                             tableOutput('state_full'))
                      ) #tabBox Paren 
                ), #tabItem Paren 
        
        tabItem(tabName = 'region',
                h3('Southern Regional Summary'), 
                p(''),
                tableOutput('state_all'),
                radioButtons('res_cat',
                             label = 'Select Resiliency Factor Statistic:',
                             choices = list('Minimum' = 'Resiliency Factor Minimum',
                                            'Maximum' = 'Resiliency Factor Maximum',
                                            'Mean' = 'Resiliency Factor Mean',
                                            'Median' = 'Resiliency Factor Median', 
                                            'Standard Deviation' = 'Resiliency Factor Standard Deviation')),
                plotlyOutput('state_sum_plot')
                ) #tabItem Paren         
        
              ) #tabItems Paren
    
      
    ) #DashboardBody Paren
    
        
) #dashboardPage Paren 
) #shinyUI Paren

