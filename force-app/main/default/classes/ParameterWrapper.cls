/**
 * @author      Abhishek Setia
 * @description Wrapper class to be used as a method parameter list
 *              to avoid PMD report error - "Excessive Parameter List"
 */
public class ParameterWrapper {
    
    public Set<Id> idSet1;
    public Set<Id> idSet2;
    public Set<Id> idSet3;
    public List<String> strList1;
    public List<String> strList2;
    public List<String> strList3;
    public String str1;
    public String str2;
    public String str3;
    public String str4;
    public String str5;
    public String str6;
    public String str7;
    public String str8;
    public String str9;
    public String str10;
    public Integer int1;
    public Integer int2;
    public Integer int3;
    public Boolean bool1;
    public Map<String,String> mapString1;
    public Map<Id,String> mapIdString1;    
    public Set<String> strSet1;
    
    /**
     * @author      Abhishek Setia
     * @description Initialize collections
     */
    public ParameterWrapper() {
        idSet1=new Set<Id>();
        idSet2=new Set<Id>();
        idSet3=new Set<Id>();
        strList1=new List<String>();
        strList2=new List<String>();
        strList3=new List<String>();
        mapString1=new Map<String,String>();
        mapIdString1=new Map<Id,String>();
        strSet1=new Set<String>();
        
    }
}