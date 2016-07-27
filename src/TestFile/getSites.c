/*** Allard Group jun.allard@uci.edu                    ***/

void getSites();


/*******************************************************************************/
//  GLOBAL VARIABLES for output control
/*******************************************************************************/


/********************************************************************************************************/
void getSites()
{
    /********* INITIALIZE ISITES *******************/
    //
    //
    //    for (iy=0;iy<iSiteTot;iy++)
    //    {
    //        iSite[iy]=0;
    //    }
    
    //switch (commandiSites)
    //{
    //case 0:
    
    switch (testRun)
    {
        case 0:  // iSites initialized for human CD3Zeta-Chain
            
            iSiteTot = 7;
            
            
            for (iy=0;iy<iSiteTot;iy++)
            {
                iSite[iy]=0;
            }
            
            iSite[0]=42;
            iSite[1]=50;
            iSite[2]=61;
            iSite[3]=89;
            iSite[4]=101;
            iSite[5]=120;
            iSite[6]=131;
            break;
            
        case 1: // iSites for formin //for testing - N=10
            
            iSiteTot = 3;
            
            for (iy=0;iy<iSiteTot;iy++)
            {
                iSite[iy]=0;
            }
            
            iSite[0]=0;
            iSite[1]=3;
            iSite[2]=7;
            break;
            
            
        case 2: //test case 2 - stiffen none, but test all iSites, make Ratio half of Ratio for case 1
            
            iSiteTot = 7;
            
            for (iy=0;iy<iSiteTot;iy++)
            {
                iSite[iy]=0;
            }
            
            iSite[0]=0;
            iSite[1]=1;
            iSite[2]=2;
            iSite[3]=3;
            iSite[4]=4;
            iSite[5]=5;
            iSite[6]=6;
            break;
            
        case 3:
            
            iSiteTot = 6;
            
            for(iy=0;iy<iSiteTot;iy++)
            {
                iSite[iy]=0;
            }
            
            iSite[0]=2;
            iSite[1]=11;
            iSite[2]=23;
            iSite[3]=35;
            iSite[4]=48;
            iSite[5]=50;
            break;
    }
    
    //break;
    
    
    
    //            case 1:
    //
    //                for (iy=0;iy<iSiteTot;iy++)
    //                {
    //                    iSite[iy]=0;
    //                }
    //
    //            printf("Total iSites: %ld", iSiteTot);
    //
    //            //for debugging
    //            for(iy=0;iy<iSiteTot;iy++)
    //        {
    //            printf("iSite[%ld] = %ld", iy, iSite[iy]);
    //        }
    //
    //                //char input[] = iSiteLocations;
    //                printf("I want to split this into tokens: %s", input);
    //                char* strArray[NMAX];
    //                char *token = strtok(input, " ");
    //
    //                //for(int j = 0; j<NMAX;j++)
    //                //{
    //                //    strArray[j] = new char[4];
    //                //}
    //
    //                while(token != NULL)
    //                {
    //                    strcpy(strArray[st],token);
    //                    printf("This is the next token: %s\n",token); //for debugging
    //                    token = strtok(NULL, " ");
    //                    st++;
    //                }
    //
    //                //for debugging
    //
    //                if (iSiteTot!=st)
    //                {
    //                    printf("Warning! iSite Total is %ld but Number of iSites in String is %ld ", iSiteTot, st);
    //                }
    //
    //                //reassign strings as doubles
    //                for(iy=0;iy<st;iy++)
    //                {
    //                    iSite[iy]=atof(strArray[iy]);
    //                }
    //
    //                //for debugging
    //                for(iy=0;iy<iSiteTot;iy++)
    //                {
    //                    printf("iSite[%ld] = %ld", iy, iSite[iy]);
    //                }
    //
    //            break;
    //    }
    
    /********* INITIALIZE BOUND ISITES *******************/
    
    if (MULTIPLE)
    {
        
        //switch () //add more cases later
        //{
        //case 0: // arbitrary subset are occupied
        
        boundTotal = 5; //total number of iSites bound
        
        iSiteBound[0]=2;
        iSiteBound[1]=11;
        iSiteBound[2]=23;
        iSiteBound[3]=35;
        iSiteBound[4]=45;

        

        
        
        //currently identifying by location
        //what is the best way to do this - identify by location or identify by iSite number?
        //pro for location - can specify locations other than iSites to be bound - but then might want to change name
        //}
    }


}

/********************************************************************************************************/
