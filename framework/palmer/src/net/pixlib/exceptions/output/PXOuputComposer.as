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

	/**
	 * The PXOuputComposer class allow to define a composition of PXExceptionOutput 
	 * instances as Exception output strategy. 
	 * 
	 * @example
	 * <listing>
	 * 
	 * var composer : PXOutputComposer = new PXOutputComposer();
	 * composer.push(new PXLoggerOutput());
	 * composer.push(new MyCustomOuput());
	 * 
	 * PXException.ouput = composer;
	 * </listing>
	 * 
	 * @langversion 3.0
	 * @playerversion Flash 10
	 * 
	 * @author Romain Ecarnot
	 */
	public class PXOuputComposer implements PXExceptionOutput
	{
		//--------------------------------------------------------------------
		// Protected properties
		//--------------------------------------------------------------------
		
		/** 
		 * Stores PXExceptionOutput instances.
		 * 
		 * @langversion 3.0
		 * @playerversion Flash 10
		 */
		protected var vOutput : Vector.<PXExceptionOutput>; 

		
		//--------------------------------------------------------------------
		// Public API
		//--------------------------------------------------------------------		
		
		/**
		 * Creates instance.
		 * 
		 * @langversion 3.0
		 * @playerversion Flash 10
		 */
		public function PXOuputComposer()
		{
			vOutput = new Vector.<PXExceptionOutput>();
		}

		/**
		 * Adds passed-in output strategy into composition.
		 * 
		 * @param output	PXExceptionOutput instance to add
		 * 
		 * @langversion 3.0
		 * @playerversion Flash 10
		 */
		public function push(output : PXExceptionOutput) : void
		{
			vOutput.push(output);
		}
		
		/**
		 * @inheritDoc
		 */
		public function output(error : Error, target : Object = null) : void
		{
			var length : uint = vOutput.length;
			for(var i : uint = 0;i < length;i++)
			{
				try
				{
					vOutput[i].output(error, target);
				}
				catch(e : Error)
				{
				}
			}
		}
	}
}