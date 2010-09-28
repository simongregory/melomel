package melomel.commands.formatters
{
import melomel.core.ObjectProxy;
import melomel.core.ObjectProxyManager;

import org.flexunit.Assert;

public class ErrorFormatterTest
{
	//---------------------------------------------------------------------
	//
	//  Setup
	//
	//---------------------------------------------------------------------

	private var message:XML;
	private var manager:ObjectProxyManager;
	private var formatter:ErrorFormatter;
	
	[Before]
	public function setUp():void
	{
		manager = new ObjectProxyManager();
		formatter = new ErrorFormatter(manager);
	}

	[After]
	public function tearDown():void
	{
		message    = null;
		manager    = null;
		formatter  = null;
	}


	//---------------------------------------------------------------------
	//
	//  Methods
	//
	//---------------------------------------------------------------------
	
	//-----------------------------
	//  Format
	//-----------------------------

	[Test]
	public function shouldFormatError():void
	{
		var error:Error;
		try {
			var err:Error = new Error("You made a mistake", 123);
			err.name = "illegal!";
			throw err;
		}
		catch(e:Error) {
			error = e;
		}
		var proxy:ObjectProxy = manager.addItem(error);
		formatter.stackTraceEnabled = false;
		message = formatter.format(error);
		Assert.assertEquals('<error proxyId="' + proxy.id + '" errorId="123" message="You made a mistake" name="illegal!"/>', message.toXMLString());
	}

	[Test]
	public function shouldFormatErrorWithStackTrace():void
	{
		var error:Error;
		try {
			throw new Error();
		}
		catch(e:Error) {
			error = e;
		}
		formatter.stackTraceEnabled = true;
		message = formatter.format(error);
		Assert.assertTrue(message.stackTrace.toString().length > 0);
	}
}
}