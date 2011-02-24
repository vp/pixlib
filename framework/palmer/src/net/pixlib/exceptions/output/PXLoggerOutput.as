/*
 * Copyright the original author or authors.
 * 
 * Licensed under the MOZILLA PUBLIC LICENSE, Version 1.1 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 * 
 *      http://www.mozilla.org/MPL/MPL-1.1.html
 * 
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */
 
package net.pixlib.exceptions.output 
{
	import net.pixlib.exceptions.PXExceptionOutput;
	import net.pixlib.log.PXDebug;
	import net.pixlib.plugin.PXPlugin;

	import flash.system.Capabilities;

	/**
	 * The PXLoggerOutput implements Pixlib Logging API to use it as Exception 
	 * message output.  
	 * 
	 * <p>This is the default exception output system.</p>
	 * 
	 * @example
	 * <listing>
	 * 
	 * PXPException.ouput = new PXLoggerOutput();
	 * </listing>
	 * 
	 * @langversion 3.0
	 * @playerversion Flash 10
	 * 
	 * @author Romain Ecarnot
	 */
	final public class PXLoggerOutput implements PXExceptionOutput
	{
		//--------------------------------------------------------------------
		// Public API
		//--------------------------------------------------------------------		
		
		/**
		 * Creates instance.
		 * 
		 * @langversion 3.0
		 * @playerversion Flash 10
		 */
		public function PXLoggerOutput()
		{
		}
		
		/**
		 * @inheritDoc
		 */
		public function output(error : Error, target : Object = null) : void
		{
			if(target is PXPlugin)
			{
				PXPlugin(target).logger.fatal(error.message, target);
				
				if(Capabilities.isDebugger) PXPlugin(target).logger.fatal(error.getStackTrace(), target);
			}
			else 
			{
				PXDebug.FATAL(error.message, target);
				if(Capabilities.isDebugger) PXDebug.FATAL(error.getStackTrace(), target);
			}
		}
	}
}
