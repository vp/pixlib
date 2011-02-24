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
package net.pixlib.exceptions
{
	import net.pixlib.exceptions.output.PXLoggerOutput;

	/**
	 * The PXException class adds ouput processing to classic Error 
	 * implementation.
	 * 
	 * @example
	 * <listing>
	 * 
	 * PXException.setOuput(new PXLoggerOutput());
	 * </listing>
	 * 
	 * @langversion 3.0
	 * @playerversion Flash 10
	 * 
	 * @author Romain Ecarnot
	 */
	public class PXException extends Error
	{
		//--------------------------------------------------------------------
		// Private properties
		//--------------------------------------------------------------------
		
		/** @private */
		private static var _OUTPUT : PXExceptionOutput = new PXLoggerOutput();

		
		//--------------------------------------------------------------------
		// Public API
		//--------------------------------------------------------------------
		
		/**
		 * Returns PXExceptionOutput system used in Exception API.
		 * 
		 * @langversion 3.0
		 * @playerversion Flash 10
		 */
		static public function get output() : PXExceptionOutput
		{
			return _OUTPUT;
		}
		
		/**
		 * Sets the PXExceptionOutput system to use in Exception API.
		 * 
		 * @param output The PXExceptionOutput ot use
		 * 
		 * @example
		 * <listing>
		 * 
		 * PXPixlibException.ouput = new PXLoggerOutput();
		 * </listing>
		 * 
		 * @langversion 3.0
		 * @playerversion Flash 10
		 */
		static public function set ouput( output : PXExceptionOutput ) : void
		{
			_OUTPUT = output;
		}

		/**
		 * Creates instance.
		 * 
		 * @param message	Error message
		 * @param target	(optional) Error source
		 * 
		 * @langversion 3.0
		 * @playerversion Flash 10
		 */
		public function PXException(message : String = "", target : Object = null)
		{
			super(message);
			
			if(_OUTPUT != null) _OUTPUT.output(this, target);
		}
	}
}