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
package net.pixlib.prefs.strategy 
{
	import net.pixlib.prefs.PXPreferences;
	import net.pixlib.services.PXSharedObjectServiceHelper;
	import net.pixlib.utils.PXSharedObjectUtils;

	/**
	 * The PXSOStrategy class implements SharedObject mecanism 
	 * as Preferences strategy.
	 * 
	 * @example
	 * <listing>
	 * 
	 * var strategy : PXPreferencesStrategy = new PXSOStrategy();
	 * 
	 * var prefs : PXPreferences = PXPreferences.get("main");
	 * prefs.strategy = strategy;
	 * prefs.addEventListener(PXPreferencesEvent.onPreferencesSaveEVENT, onSaveHandler);
	 * prefs.setValue("name", "Pixlib");
	 * prefs.save();
	 * </listing>
	 * 
	 * @see PIXSERVICE_DOC/net/pixlib/services/PXSharedObjectService.html net.pixlib.services.PSSharedObjectService
	 * 
	 * @langversion 3.0
	 * @playerversion Flash 10
	 * 
	 * @author Romain Ecarnot
	 */
	public class PXSOStrategy extends PXAbstractStrategy
	{
		//--------------------------------------------------------------------
		// Private properties
		//--------------------------------------------------------------------
		
		/** @private */
		private var _helper : PXSharedObjectServiceHelper; 
		
		
		//--------------------------------------------------------------------
		// Public API
		//--------------------------------------------------------------------
		
		/**
		 * Creates instance.
		 * 
		 * @param	name		The name of the shared object.
		 * @param	localPath	The full or partial path to the SWF file that 
		 * 						created the	shared object, and that determines 
		 * 						where the shared object will be stored locally. 
		 * 						If you do not specify this parameter, 
		 * 						the root "/" is used.
		 * 	@param	secure		Determines whether access to this shared object 
		 * 						is restricted to SWF files that are delivered 
		 * 						over an HTTPS connection.(default is false)
		 * 						
		 * @langversion 3.0
		 * @playerversion Flash 10
		 */				
		public function PXSOStrategy( name : String = "preferences", localPath : String = "/", secure : Boolean = false )
		{
			super();
			
			_helper = new PXSharedObjectServiceHelper(name, localPath, secure);
		}

		
		//--------------------------------------------------------------------
		// Protected methods
		//--------------------------------------------------------------------
				
		/**
		 * Loads preferences data using SharedObject strategy.
		 * 
		 * @param preferences	PXPreferences owner
		 * 
		 * @langversion 3.0
		 * @playerversion Flash 10
		 */
		override protected function onLoad(preferences : PXPreferences) : void
		{
			var data : Object = PXSharedObjectUtils.loadLocal(_helper.name, preferences.id, _helper.localPath, _helper.secure) || {};
			
			if(onLoadCallback is Function) onLoadCallback(data);
		}
		
		/**
		 * Saves preferences data using SharedObject strategy.
		 * 
		 * @param preferences	PXPreferences owner
		 * @param data			Raw data to save
		 * 
		 * @langversion 3.0
		 * @playerversion Flash 10
		 */
		override protected function onSave(preferences : PXPreferences, data : Object) : void
		{
			var success : Boolean = PXSharedObjectUtils.saveLocal(_helper.name, preferences.id, data, _helper.localPath, _helper.secure);
			
			if(onSaveCallback is Function) onSaveCallback(success);
		}
	}
}
