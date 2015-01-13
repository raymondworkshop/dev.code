using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

namespace ScoreListUsingGeoHashing
{
    class GlobalConst
    {

#if DEBUG
        //FVC
        /*
        public const int ENROLL_SUB_START = 4;
        public const int ENROLL_SUB_END = 5;
        public const int SEARCH_SUB_START = 5;
        public const int SEARCH_SUB_END = 8;
         */
        
        public const int ENROLL_SUB_START = 0;
        public const int ENROLL_SUB_END = 1;
        public const int SEARCH_SUB_START = 1;
        public const int SEARCH_SUB_END = 8;
        

        public const int MINUTIAE_SAMPLE_COUNT = 8;
        public const int FILE_COUNT = 100;
        public const int SELECTED_FILES = FILE_COUNT;
        public const int CANDIDATE_COUNT = 30;
        public const int CANDIDATE_ENROLL_COUNT = 4;
# else
        //NIST
        public const int ENROLL_SUB_START = 0;
        public const int ENROLL_SUB_END = 1;
        public const int SEARCH_SUB_START = 1;
        public const int SEARCH_SUB_END = 2;

        //public const int MINUTIAE_SAMPLE_COUNT = 2;
        //public const int FILE_COUNT = 27000;
        //public const int SELECTED_FILES = 22000;
        //public const int CANDIDATE_COUNT = 3600;
        //public const int CANDIDATE_ENROLL_COUNT = 1;


        public const int MINUTIAE_SAMPLE_COUNT = 2;
        public const int FILE_COUNT = 2700;
        public const int SELECTED_FILES = FILE_COUNT;
        //candidate list is 396 and penetrate rate is 15%
        public const int CANDIDATE_COUNT = 396;
        public const int CANDIDATE_ENROLL_COUNT = 1;

# endif
    }
}
