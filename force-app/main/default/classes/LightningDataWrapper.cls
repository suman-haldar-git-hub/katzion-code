/**
 * @author      Abhishek Setia
 * @description Datatable wrapper used in LWC.
 *              Optional - Used in JS library for custom sorting. 
 *              (Refer LightningDataTableSorting.js in static resource 'CustomScript')
 *                       - Used in Server side sorting.                
 */
public class LightningDataWrapper{
    
    // Sorting parameters
    private static String sortKey;
    private static String sortDirection;

    
    /**
     * author       Abhishek Setia
     * @description Sets sortKey, sortDirection properties.
     * @param       sortKey1 - Sorting column
     * @param       sortDirection1
     */
    public static void setSortingOrder(String sortKey1, String sortDirection1){
        sortKey=sortKey1;
        sortDirection=sortDirection1;
    }

    /**
     * @author      Abhishek Setia
     * @description Maps to record
     */
    public class LightningDataRow implements Comparable{
    
        @AuraEnabled
        public String stringA;
        @AuraEnabled
        public String stringB;
        @AuraEnabled
        public String stringC;
        @AuraEnabled
        public String stringD;
        @AuraEnabled
        public String stringE;
        @AuraEnabled
        public Datetime datetimeA;
        @AuraEnabled
        public Datetime datetimeB;        

        /**
         * @author      Abhishek Setia
         * @description Implementing method of interface Comparable
         * @param       compareTo - Object to compare
         * @return      Integer
         */
        public Integer compareTo(Object compareTo) {
            LightningDataRow ldw = (LightningDataRow)compareTo;
            if(sortKey=='stringA'){
                return compareStringA(ldw);
            }else if(sortKey=='stringB'){
                return compareStringB(ldw);
            }else if(sortKey=='stringC'){
                return compareStringC(ldw);
            }else if(sortKey=='stringD'){
                return compareStringD(ldw);
            }else if(sortKey=='stringE'){
                return compareStringE(ldw);
            }else if(sortKey=='datetimeA'){
                return compareDatetimeA(ldw);
            }else if(sortKey=='datetimeB'){
                return compareDatetimeB(ldw);
            }
            return 0;
        }
        
        /**
         * @author      Abhishek Setia
         * @description compare 'stringA' column for sorting
         * @param       ldw - Type LightningDataRow
         * @return      Integer
         */
        Integer compareStringA(LightningDataRow ldw){
            Integer retVal=0;
            if(sortDirection=='asc'){
                retVal = stringA.compareTo(ldw.stringA);
            }else{
                retVal = ldw.stringA.compareTo(stringA);
            }
            return retVal;
        }

        /**
         * @author      Abhishek Setia
         * @description compare 'stringB' column for sorting
         * @param       ldw - Type LightningDataRow
         * @return      Integer
         */
        Integer compareStringB(LightningDataRow ldw){
            Integer retVal=0;
            if(sortDirection=='asc'){
                retVal = stringB.compareTo(ldw.stringB);
            }else{
                retVal = ldw.stringB.compareTo(stringB);
            }
            return retVal;
        }

        /**
         * @author      Abhishek Setia
         * @description compare 'stringC' column for sorting
         * @param       ldw - Type LightningDataRow
         * @return      Integer
         */
        Integer compareStringC(LightningDataRow ldw){
            Integer retVal=0;
            if(sortDirection=='asc'){
                retVal = stringC.compareTo(ldw.stringC);
            }else{
                retVal = ldw.stringC.compareTo(stringC);
            }
            return retVal;
        }

        /**
         * @author      Abhishek Setia
         * @description compare 'stringD' column for sorting
         * @param       ldw - Type LightningDataRow
         * @return      Integer
         */
        Integer compareStringD(LightningDataRow ldw){
            Integer retVal=0;
            if(sortDirection=='asc'){
                retVal = stringD.compareTo(ldw.stringD);
            }else{
                retVal = ldw.stringD.compareTo(stringD);
            }
            return retVal;
        }

        /**
         * @author      Abhishek Setia
         * @description compare 'stringE' column for sorting
         * @param       ldw - Type LightningDataRow
         * @return      Integer
         */
        Integer compareStringE(LightningDataRow ldw){
            Integer retVal=0;
            if(sortDirection=='asc'){
                retVal = stringE.compareTo(ldw.stringE);
            }else{
                retVal = ldw.stringE.compareTo(stringE);
            }
            return retVal;
        }

        /**
         * @author      Abhishek Setia
         * @description compare 'datetimeA' column for sorting
         * @param       ldw - Type LightningDataRow
         * @return      Integer
         */
        Integer compareDatetimeA(LightningDataRow ldw){
            Integer retVal=0;
            if(sortDirection=='asc'){
                if(datetimeA>ldw.datetimeA){
                    retVal=1;
                }else{
                    retVal=-1;
                }
            }else{
                if(datetimeA<ldw.datetimeA){
                    retVal=1;
                }else{
                    retVal=-1;
                }
            }
            return retVal;
        }

        /**
         * @author      Abhishek Setia
         * @description compare 'datetimeB' column for sorting
         * @param       ldw - Type LightningDataRow
         * @return      Integer
         */
        Integer compareDatetimeB(LightningDataRow ldw){
            Integer retVal=0;
            if(sortDirection=='asc'){
                if(datetimeB>ldw.datetimeB){
                    retVal=1;
                }else{
                    retVal=-1;
                }
            }else{
                if(datetimeB<ldw.datetimeB){
                    retVal=1;
                }else{
                    retVal=-1;
                }
            }
            return retVal;
        }
    }
}