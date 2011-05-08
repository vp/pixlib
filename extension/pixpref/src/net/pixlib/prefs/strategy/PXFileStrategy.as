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

	import flash.filesystem.File;
	import flash.filesystem.FileMode;
	import flash.filesystem.FileStream;

	/**
	 * The PXFileStrategy class implements File mecanism 
	 * as PXPreferences strategy.
	 * 
	 * @example
	 * <listing>
	 * 
	 * var strategy : PXPreferencesStrategy = new PXFileStrategy();
	 * 
	 * var prefs : PXPreferences = PXPreferences.get("main");
	 * prefs.strategy = strategy;
	 * prefs.addEventListener(PXPreferencesEvent.onPreferencesSaveEVENT, onSaveHandler);
	 * prefs.setValue("name", "Pixlib");
	 * prefs.save();
	 * </listing>
	 * 
	 * @langversion 3.0
	 * @playerversion Flash 10
	 * 
	 * @author Romain Ecarnot
	 */
	public class PXFileStrategy extends PXAbstractStrategy
	{
		// --------------------------------------------------------------------
		// Public API
		// --------------------------------------------------------------------

		/**
		 * Creates instance.
		 * 
		 * @langversion 3.0
		 * @playerversion Flash 10
		 */
		public function PXFileStrategy()
		{
			super();
		}


		// --------------------------------------------------------------------
		// Protected methods
		// --------------------------------------------------------------------

		/**
		 * Loads preferences data using File strategy.
		 * 
		 * @param preferences	PXPreferences owner
		 * 
		 * @langversion 3.0
		 * @playerversion Flash 10
		 */
		override protected function onLoad(preferences : PXPreferences) : void
		{
			var file : File = File.applicationStorageDirectory.resolvePath(preferences.id);
			var data : Object = null;
			
			if(file.exists)
			{
				var fs : FileStream = new FileStream();
				try
				{
					fs.open(file, FileMode.READ);
					data = fs.readObject();
				}
				finally
				{
					fs.close();
					fs = null;
					file = null;
				}
			}
			
			if (onLoadCallback is Function) onLoadCallback(data);
		}

		/**
		 * Saves preferences data using File strategy.
		 * 
		 * @param preferences	PXPreferences owner
		 * @param data			Raw data to save
		 * 
		 * @langversion 3.0
		 * @playerversion Flash 10
		 */
		override protected function onSave(preferences : PXPreferences, data : Object) : void
		{
			var file : File = File.applicationStorageDirectory.resolvePath(preferences.id);
			var fs : FileStream = new FileStream();
			var b : Boolean = true;

			try
			{
				fs.open(file, FileMode.WRITE);
				fs.writeObject(data);
			}
			catch(e : Error)
			{
				b = false;
			}
			finally
			{
				fs.close();
				fs = null;
				file = null;

				if (onSaveCallback is Function) onSaveCallback(b);
			}
		}
	}
}
