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
package net.pixlib.load.collection
{
	import net.pixlib.commands.PXCommandMS;
	import net.pixlib.commands.PXDelegate;

	/**
	 * The PXDelayLoader act as a standard PXQueueLoader adding delay 
	 * between next loading call.
	 * 
	 * @langversion 3.0
	 * @playerversion Flash 10
	 * 
	 * @author Romain Ecarnot
	 */
	public class PXDelayLoader extends PXQueueLoader
	{
		//--------------------------------------------------------------------
		// Protected properties
		//--------------------------------------------------------------------
		
		/** 
		 * Delay between each loading step in milliseconds.
		 * 
		 * @default 500
		 * 
		 * @langversion 3.0
		 * @playerversion Flash 10
		 */
		protected var nDelay : uint; 

		
		//--------------------------------------------------------------------
		// Public properties
		//--------------------------------------------------------------------
				
		/**
		 * The delay between each loading step in milliseconds.
		 * 
		 * @langversion 3.0
		 * @playerversion Flash 10
		 */
		public function get delay() : uint
		{
			return nDelay;
		}

		/** @private */
		public function set delay( value : uint) : void
		{
			nDelay = value;
		}

		
		//--------------------------------------------------------------------
		// Public API
		//--------------------------------------------------------------------
		
		/**
		 * Creates a new PXDelayLoader instance.
		 * 
		 * @param delay	Delay in millisecondes between each loading process
		 * 
		 * @langversion 3.0
		 * @playerversion Flash 10
		 */
		public function PXDelayLoader( delay : uint = 500 )
		{
			super();
			
			nDelay = delay;
		}

		
		//--------------------------------------------------------------------
		// Protected methods
		//--------------------------------------------------------------------
		
		/**
		 * @inheritDoc
		 */
		override protected function startNextLoader( ) : void
		{
			if(nIndex == 0)
			{
				super.startNextLoader();
			}
			else
			{
				PXCommandMS.getInstance().delay(new PXDelegate(super.startNextLoader), delay);
			}
		}
	}
}