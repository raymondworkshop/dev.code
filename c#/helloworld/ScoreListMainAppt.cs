using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
//This is the namespace of MccIndexerNewMainApp class
using MccIndexer;
using System.IO;
using BioLab.Biometrics.Mcc.Sdk;

namespace ScoreListUsingGeoHashing
{
    /*
     * 本程序主要检验MCC-LSH算法执行结果。其结果，也就是候选项列表，将会存储在output文件夹下。利用Matlab的程序就可以打印出一副penerate rate图。
     * debug版本用于处理FVC，而Release版本用于NIST和54000的实验。
     * 
     *  >Updated by wenlong
     *  This program returns the result of MCC-LSH Algorithms; The procedure:
     *  
     *    *  create a new MCC index:
     *        - MccIndexerNewMainApp dt = new MccIndexerNewMainApp();
     *             - MccSdk.CreateMccIndex(8, 6, 24, 32, 30, 2, Math.PI / 4.0, 256, 17);  //17 is random seed used to calculate the starting value for the pseudo-random hash functions
     *        
     *    *  Enroll data: 
     *       adds new minutiae templates stored in text format to the current MCC index  
     *        - dt.EnrollModelFile(inputDir + "/" + minuArray[i, j].FileName);
     *             - MccSdk.AddTextTemplateToMccIndex(fullFilePath, id); //id of the minutiae template to be added, and is the prefix of the text
     *        
     *    *  Search the minutiae template:
     *       searchs a minutiae template stored in text format into the current MCC index, 
     *       and returns a candidate list containing the IDs of the most similar indexed candidates sorted by similarity in descending order.
     *        - dt.CalculateScore(inputDir + "/" + minuArray[i, j].FileName);
     *             - MccSdk.SearchTextTemplateIntoMccIndex(fullFilePath,false,out sortedSimilarities);
     *             
     *    *  So, the questions are
     *        -  Why does the algorithms include the the enroll step?
     *        -  What does the similar mean?
     *             
     */
    class Minutiae
    {
        public string FileName = null;
        public int MajorIdMius1 = -1;
        public int MinIdMius1 = -1;
        
        public Minutiae()
        {

        }

        public Minutiae(string fileName)
        {
            this.FileName = fileName;

        }

        public void parseID()
        {
            if (FileName == null)
            {
                return;
            }
            string[] item = FileName.Split('_');
            MajorIdMius1 = int.Parse(item[0]) - 1;
            item = item[1].Split('.');
            MinIdMius1 = int.Parse(item[0]) - 1;
        }
    }

    class ScoreListMainApp
    {
        //To Store Finger list;
        //Multidimensional arrays:
        private Minutiae[,] minuArray;

        string inputDir = null;
        string outputDir = null;

        //create a new MCC index
        MccIndexerNewMainApp dt = new MccIndexerNewMainApp();

        public ScoreListMainApp()
        {
            minuArray = new Minutiae[GlobalConst.FILE_COUNT, GlobalConst.MINUTIAE_SAMPLE_COUNT];

            for (int i = 0; i < GlobalConst.FILE_COUNT; ++i)
            {
                for (int j = 0; j < GlobalConst.MINUTIAE_SAMPLE_COUNT; ++j)
                {
                    minuArray[i, j] = null;
                }
            }

            string temp = Directory.GetCurrentDirectory();
            inputDir = temp + "/input";
            outputDir = temp + "/output";
        }


        public void collectFiles() 
        {
            //some syntax - 
            // DirectoryInfo exposes instance methods for directory
            DirectoryInfo directInfoInputDir = new DirectoryInfo(inputDir);
            //FileInfo provides instance methods for files
            FileInfo[] fileList = directInfoInputDir.GetFiles();
            foreach (FileInfo fileInfoItem in fileList)
            {
                Minutiae minu = new Minutiae(fileInfoItem.Name);
                minu.parseID();
                minuArray[minu.MajorIdMius1, minu.MinIdMius1] = minu;
            }
        }

        private void enrollData() 
        {
            int i, j;
            for (i = 0; i < GlobalConst.SELECTED_FILES; ++i)
            {
                for (j = GlobalConst.ENROLL_SUB_START; j < GlobalConst.ENROLL_SUB_END; ++j)
                {
                    if (minuArray[i, j]!=null)
                    {
                        //Minutiae.FileName
                        //This way can get the FileName, because in the line 83, object Minutiae get the Name firstly
                        Console.WriteLine(minuArray[i, j].FileName);

                        //adds a new minutiae template stored in text format to the current MCC index - id
                        dt.EnrollModelFile(inputDir + "/" + minuArray[i, j].FileName);
                    }                   
                }
            }
        }

        private string getMaxID(string source)
        {
            string[] s = source.Split('_');
            return s[0];
        }


        private void sortDictionaryAndPrint(ref long[] list, string currentItem, StreamWriter sw1) 
        {
            // some syntax -
            // The ref keyword causes an argument to be passed by reference, not by value
            // StreamWriter class implements a TextWriter for writing characters to a stream in a particular encoding 
            // TextWriter is the abstract base class of StreamWriter and StringWriter 
            int i = 1;

            // some c# syntax -
            // StringBuilder represents a mutable string of characters
            StringBuilder fileId = new StringBuilder();

            fileId.Append(getMaxID(currentItem) + ";");

            foreach (long item in list)
            {
                if (i > GlobalConst.CANDIDATE_COUNT)
                {
                    break;
                }
                fileId.Append(item + ";");
                i = i + 1;
            }
            // syntax -
            //WriteLine writes the specified data, followed by the current line terminator, to the standard output stream.
            sw1.WriteLine(fileId);
            //Flush() can be called any time to clear the buffer, and the stream will remain open
            sw1.Flush();
        }

        public void calcuScoreVector()
        {
            
            int i, j;
            // syntax -
            //Dictionary keyword represents a collection of keys and values
            Dictionary<string, int> result = new Dictionary<string, int>();
            // syntax -
            //FileStream class exposes a Stream around a file,supporting both synchronous and asynchronous read and write operations
            FileStream fs1 = null;
            StreamWriter sw1 = null;
            int enrollCount = GlobalConst.ENROLL_SUB_END - GlobalConst.ENROLL_SUB_START;

            // syntax -
            // FileStream creates a file
            fs1 = new FileStream(outputDir + "/" + enrollCount + ".txt", FileMode.Create);
            // syntax -
            // create an instance of StreamWriter to write text to file fs1
            sw1 = new StreamWriter(fs1);

            TimeSpan ts1 = new TimeSpan(DateTime.Now.Ticks); 

            enrollData();

            TimeSpan ts2 = new TimeSpan(DateTime.Now.Ticks);
            TimeSpan ts = ts2.Subtract(ts1).Duration();
            string spanTotalSeconds = ts.TotalSeconds.ToString();
            Console.WriteLine("Enroll time: " + spanTotalSeconds);

            ts1 = new TimeSpan(DateTime.Now.Ticks);

            for (i = 0; i < GlobalConst.SELECTED_FILES; ++i)
            {
                for (j = GlobalConst.SEARCH_SUB_START; j < GlobalConst.SEARCH_SUB_END; ++j)
                {
                    if (minuArray[i, j] == null)
                    {
                        continue;
                    }
                    //Console.WriteLine("Cal " + minuArray[i, j].FileName);
                    long[] list = dt.CalculateScore(inputDir + "/" + minuArray[i, j].FileName);
                    if (list == null)
                    {
                        continue;
                    }
                    sortDictionaryAndPrint(ref list, minuArray[i, j].FileName, sw1);
                }
            }

            sw1.Flush();
            //Clears buffers for this stream and causes any buffered data to be written to the file
            fs1.Flush();
            sw1.Close();
            fs1.Close();

            ts2 = new TimeSpan(DateTime.Now.Ticks);
            ts = ts2.Subtract(ts1).Duration();
            spanTotalSeconds = ts.TotalSeconds.ToString();
            Console.WriteLine("Search time: " + spanTotalSeconds);   

        }


        //Use the static modifier to declare a static member, which belongs to the type itself rather than to a specific object. 
        static void Main(string[] args)
        {
             
            //load and set the MCC enroll parameters from an XML file
            //If this is not called, the SDK uses the default parameters 
            MccSdk.SetMccEnrollParameters("MccEnrollParams.xml");
            MccSdk.SetMccMatchParameters("MccMatchParams.xml");
            
            ScoreListMainApp app = new ScoreListMainApp();
            app.collectFiles();
            app.calcuScoreVector();
        }
    }
}
