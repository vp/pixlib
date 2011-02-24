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
package net.pixlib.plugin 
{
	import net.pixlib.core.PXCoreFactory;
	import net.pixlib.events.PXEventChannel;
	
	/**
	 * Default implementation of a Plugin.
	 * 
	 * <p>Use by default if none plugin are created.</p>
	 * 
	 * @langversion 3.0
	 * @playerversion Flash 10
	 * 
	 * @author Francis Bourre
	 */
	final public class PXBasePlugin extends PXAbstractPlugin
	{
		//--------------------------------------------------------------------
		// Private properties
		//--------------------------------------------------------------------

		private static var _oI : PXBasePlugin;

		
		//--------------------------------------------------------------------
		// Public API
		//--------------------------------------------------------------------
		
		/**
		 * 
		 * 
		 * @langversion 3.0
		 * @playerversion Flash 10
		 */		
		public static function getInstance() : PXBasePlugin
		{
			if ( !(_oI is PXBasePlugin)) _oI = new PXBasePlugin();
			return _oI;
		}

		/**
		 * @inheritDoc
		 */
		public static function release() : void
		{
			if (_oI is PXBasePlugin)
			{
				_oI.release();
				_oI = null;
			}
		}
		
		/**
		 * @inheritDoc
		 */
		override protected function initialize() : void
		{
			PXChannelExpert.getInstance().registerChannel(new PXEventChannel(toString()));
			PXCoreFactory.getInstance().register(name, this);
			super.initialize();
		}
		
		//--------------------------------------------------------------------
		// Private implementation
		//--------------------------------------------------------------------
		
		/**
		 * @private
		 */
		function PXBasePlugin()
		{
			
		}		
	}
}