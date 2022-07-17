/**
 * @author : Sunil
 * @company : Cognizant
 * @description : This class is used as framework for trigger handler classes.
*/
@isTest
private class TriggerHandlerTest {
    
    private static final String TRIGGER_CONTEXT_ERROR = 'Trigger handler called outside of Trigger execution';
    
    private static String lastMethodCalled;
    
    private static TriggerHandlerTest.TestHandler handler;
    
    static {
        handler = new TriggerHandlerTest.TestHandler();
        // override its internal trigger detection
        handler.isTriggerExecuting = true;
    }
    
    /***************************************
* unit tests
***************************************/
    /**
* @author : Sunil
* @description : contexts tests.
*/
    @isTest
    static void testBeforeInsert() {
        beforeInsertMode();
        handler.run('LogWebCalloutEventTrigger');
        System.assertEquals('beforeInsert', lastMethodCalled, 'last method should be beforeInsert');
    }
    /**
* @author : Sunil
* @description : contexts tests.
*/
    @isTest
    static void testBeforeUpdate() {
        beforeUpdateMode();
        handler.run('LogWebCalloutEventTrigger');
        System.assertEquals('beforeUpdate', lastMethodCalled, 'last method should be beforeUpdate');
    }
    /**
* @author : Sunil
* @description : contexts tests.
*/
    @isTest
    static void testBeforeDelete() {
        beforeDeleteMode();
        handler.run('LogWebCalloutEventTrigger');
        System.assertEquals('beforeDelete', lastMethodCalled, 'last method should be beforeDelete');
    }
    /**
* @author : Sunil
* @description : contexts tests.
*/
    @isTest
    static void testAfterInsert() {
        afterInsertMode();
        handler.run('LogWebCalloutEventTrigger');
        System.assertEquals('afterInsert', lastMethodCalled, 'last method should be afterInsert');
    }
    /**
* @author : Sunil
* @description : contexts tests.
*/
    @isTest
    static void testAfterUpdate() {
        afterUpdateMode();
        handler.run('LogWebCalloutEventTrigger');
        System.assertEquals('afterUpdate', lastMethodCalled, 'last method should be afterUpdate');
    }
    /**
* @author : Sunil
* @description : contexts tests.
*/
    @isTest
    static void testAfterDelete() {
        afterDeleteMode();
        handler.run('LogWebCalloutEventTrigger');
        System.assertEquals('afterDelete', lastMethodCalled, 'last method should be afterDelete');
    }
    /**
* @author : Sunil
* @description : contexts tests.
*/
    @isTest
    static void testAfterUndelete() {
        afterUndeleteMode();
        handler.run('LogWebCalloutEventTrigger');
        System.assertEquals('afterUndelete', lastMethodCalled, 'last method should be afterUndelete');
    }
    /**
* @author : Sunil
* @description : contexts tests.
*/
    @isTest 
    static void testNonTriggerContext() {
        try{
            handler.run('LogWebCalloutEventTrigger');
            System.assert(false, 'the handler ran but should have thrown');
        } catch(TriggerHandler.TriggerHandlerException te) {
            System.assertEquals(TRIGGER_CONTEXT_ERROR, te.getMessage(), 'the exception message should match');
        } catch(Exception e) {
            System.assert(false, 'the exception thrown was not expected: ' + e.getTypeName() + ': ' + e.getMessage());
        }
    }
    /**
* @author : Sunil
* @description : test bypass api.
*/
    @isTest
    static void testBypassAPI() {
        afterUpdateMode();
        
        // test a bypass and run handler
        TriggerHandler.bypass('TestHandler');
        handler.run('LogWebCalloutEventTrigger');
        System.assertEquals(null, lastMethodCalled, 'last method should be null when bypassed');
        System.assertEquals(true, TriggerHandler.isBypassed('TestHandler'), 'test handler should be bypassed');
        resetTest();
        
        // clear that bypass and run handler
        TriggerHandler.clearBypass('TestHandler');
        handler.run('LogWebCalloutEventTrigger');
        System.assertEquals('afterUpdate', lastMethodCalled, 'last method called should be afterUpdate');
        System.assertEquals(false, TriggerHandler.isBypassed('TestHandler'), 'test handler should be bypassed');
        resetTest();
        
        // test a re-bypass and run handler
        TriggerHandler.bypass('TestHandler');
        handler.run('LogWebCalloutEventTrigger');
        System.assertEquals(null, lastMethodCalled, 'last method should be null when bypassed');
        System.assertEquals(true, TriggerHandler.isBypassed('TestHandler'), 'test handler should be bypassed');
        resetTest();
        
        // clear all bypasses and run handler
        TriggerHandler.clearAllBypasses();
        handler.run('LogWebCalloutEventTrigger');
        System.assertEquals('afterUpdate', lastMethodCalled, 'last method called should be afterUpdate');
        System.assertEquals(false, TriggerHandler.isBypassed('TestHandler'), 'test handler should be bypassed');
        resetTest();
    }
    /**
* @author : Sunil
* @description : instance method tests.
*/
    @isTest
    static void testLoopCount() {
        beforeInsertMode();
        
        // set the max loops to 2
        handler.setMaxLoopCount(2);
        
        // run the handler twice
        handler.run('LogWebCalloutEventTrigger');
        handler.run('LogWebCalloutEventTrigger');
        
        // clear the tests
        resetTest();
        
        try {
            // try running it. This should exceed the limit.
            handler.run('LogWebCalloutEventTrigger');
            System.assert(false, 'the handler should throw on the 3rd run when maxloopcount is 3');
        } catch(TriggerHandler.TriggerHandlerException te) {
            // we're expecting to get here
            System.assertEquals(null, lastMethodCalled, 'last method should be null');
        } catch(Exception e) {  
            System.assert(false, 'the exception thrown was not expected: ' + e.getTypeName() + ': ' + e.getMessage());
        }
        
        // clear the tests
        resetTest();
        
        // now clear the loop count
        handler.clearMaxLoopCount();
        
        try {
            // re-run the handler. We shouldn't throw now.
            handler.run('LogWebCalloutEventTrigger');
            System.assertEquals('beforeInsert', lastMethodCalled, 'last method should be beforeInsert');
        } catch(TriggerHandler.TriggerHandlerException te) {
            System.assert(false, 'running the handler after clearing the loop count should not throw');
        } catch(Exception e) {  
            System.assert(false, 'the exception thrown was not expected: ' + e.getTypeName() + ': ' + e.getMessage());
        }
    }
     /**
* @author : Sunil
* @description : instance method tests.
*/
    @isTest
    static void testLoopCountClass() {
        TriggerHandler.LoopCount lc = new TriggerHandler.LoopCount();
        System.assertEquals(5, lc.getMax(), 'max should be five on init');
        System.assertEquals(0, lc.getCount(), 'count should be zero on init');
        
        lc.increment();
        System.assertEquals(1, lc.getCount(), 'count should be 1');
        System.assertEquals(false, lc.exceeded(), 'should not be exceeded with count of 1');
        
        lc.increment();
        lc.increment();
        lc.increment();
        lc.increment();
        System.assertEquals(5, lc.getCount(), 'count should be 5');
        System.assertEquals(false, lc.exceeded(), 'should not be exceeded with count of 5');
        
        lc.increment();
        System.assertEquals(6, lc.getCount(), 'count should be 6');
        System.assertEquals(true, lc.exceeded(), 'should not be exceeded with count of 6');
    }
     /**
* @author : Sunil
* @description : private method tests.
*/
    @isTest 
    static void testGetHandlerName() {
        System.assertEquals('TestHandler', handler.getHandlerName(), 'handler name should match class name');
    }
    /**
* @author : Sunil
* @description : test virtual methods.
*/
    @isTest
    static void testVirtualMethods() {
        TriggerHandler h = new TriggerHandler();
        h.beforeInsert();
        h.beforeUpdate();
        h.beforeDelete();
        h.afterInsert();
        h.afterUpdate();
        h.afterDelete();
        h.afterUndelete();
        System.assertNotEquals(h, null);
    }
    
    /***************************************
* testing utilities
***************************************/
    /**
* @author : Sunil
* @description : reset test method.
*/
    private static void resetTest() {
        lastMethodCalled = null;
    }
    
    // modes for testing
    /**
* @author : Sunil
* @description : This method will execute before Insert.
*/
    private static void beforeInsertMode() {
        handler.setTriggerContext('before insert', true);
    }
    /**
* @author : Sunil
* @description : This method will execute before Update.
*/
    private static void beforeUpdateMode() {
        handler.setTriggerContext('before update', true);
    }
    /**
* @author : Sunil
* @description : This method will execute before Delete.
*/
    private static void beforeDeleteMode() {
        handler.setTriggerContext('before delete', true);
    }
    /**
* @author : Sunil
* @description : This method will execute after Insert.
*/
    private static void afterInsertMode() {
        handler.setTriggerContext('after insert', true);
    }
    /**
* @author : Sunil
* @description : This method will execute after Update.
*/
    private static void afterUpdateMode() {
        handler.setTriggerContext('after update', true);
    }
    /**
* @author : Sunil
* @description : This method will execute after Delete.
*/
    private static void afterDeleteMode() {
        handler.setTriggerContext('after delete', true);
    }
    /**
* @author : Sunil
* @description : This method will execute Undelete.
*/
    private static void afterUndeleteMode() {
        handler.setTriggerContext('after undelete', true);
    }
    
    // 
    /**
 * @author : Sunil
 * @company : Cognizant
 * @description : This class is used as test implementation of the TriggerHandler.
*/
    private class TestHandler extends TriggerHandler {
        /**
* @author : Sunil
* @description : This method will execute before Insert.
*/
        public override void beforeInsert() {
            TriggerHandlerTest.lastMethodCalled = 'beforeInsert';
        }
        /**
* @author : Sunil
* @description : This method will execute before Update.
*/
        public override void  beforeUpdate() {
            TriggerHandlerTest.lastMethodCalled = 'beforeUpdate';
        }
        /**
* @author : Sunil
* @description : This method will execute before Delete.
*/
        public override void beforeDelete() {
            TriggerHandlerTest.lastMethodCalled = 'beforeDelete';
        }
        /**
* @author : Sunil
* @description : This method will execute after Insert.
*/
        public override void afterInsert() {
            TriggerHandlerTest.lastMethodCalled = 'afterInsert';
        }
        /**
* @author : Sunil
* @description : This method will execute after Update.
*/
        public override void afterUpdate() {
            TriggerHandlerTest.lastMethodCalled = 'afterUpdate';
        }
        /**
* @author : Sunil
* @description : This method will execute after Delete.
*/
        public override void afterDelete() {
            TriggerHandlerTest.lastMethodCalled = 'afterDelete';
        }
        /**
* @author : Sunil
* @description : This method will execute after Undelete.
*/
        public override void afterUndelete() {
            TriggerHandlerTest.lastMethodCalled = 'afterUndelete';
        }
        
    }
    
}