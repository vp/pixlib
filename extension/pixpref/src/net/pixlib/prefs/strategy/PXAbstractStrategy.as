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
	import net.pixlib.exceptions.PXIllegalArgumentException;
	import net.pixlib.exceptions.PXUnimplementedMethodException;
	import net.pixlib.log.PXStringifier;
	import net.pixlib.prefs.PXPreferences;

	/**
	 * The PXAbstractStrategy class implements default features 
	 * for PXPreferences strategy.
	 * 
	 * <p>Work as an abstract class, so don't instanciate it directly, use 
	 * concrete implementations.</p>
	 * 
	 * @langversion 3.0
	 * @playerversion Flash 10
	 * 
	 * @author Romain Ecarnot
	 */
	public class PXAbstractStrategy implements PXPreferencesStrategy 
	{
		//--------------------------------------------------------------------
		// Protected properties
		//--------------------------------------------------------------------
		
		/**
		 * Stores the method to call when data are loaded.
		 * 
		 * @langversion 3.0
		 * @playerversion Flash 10
		 */
		protected var onLoadCallback : Function;
		
		/**
		 * Stores the method to call when data are saved.
		 * 
		 * @langversion 3.0
		 * @playerversion Flash 10
		 */
		protected var onSaveCallback : Function;  
		
		
		//--------------------------------------------------------------------
		// Public properties
		//--------------------------------------------------------------------
		
		/**
		 * @inheritDoc
		 */
		public function set onLoadHandler(func : Function) : void
		{
			onLoadCallback = func;
		}
		
		/**
		 * @inheritDoc
		 */
		public function set onSaveHandler(func : Function) : void
		{
			onSaveCallback = func;
		}

		
		//--------------------------------------------------------------------
		// Public API
		//--------------------------------------------------------------------
		
		/**
		 * @inheritDoc
		 */
		final public function load(preferences : PXPreferences) : void
		{
			if(preferences != null)
			{
				onLoad(preferences);
			}
			else
			{
				var msg : String = "load() failed. Preferences is null.";
				throw new PXIllegalArgumentException(msg, this);
			}
		}

		/**
		 * @inheritDoc
		 */
		final public function save(preferences : PXPreferences, data : Object) : void
		{
			if(preferences != null)
			{
				onSave(preferences, data);
			}
			else
			{
				var msg : String = "save() failed. Preferences is null.";
				throw new PXIllegalArgumentException(msg, this);
			}
		}

		/**
		 * @inheritDoc
		 */
		public function release() : void
		{
			onLoadCallback = null;
			onSaveCallback = null;
		}

		/**
		 * Returns string represenation of instance.
		 * 
		 * @return string representation of instance
		 * 
		 * @langversion 3.0
		 * @playerversion Flash 10
		 */
		public function toString() : String
		{
			return PXStringifier.process(this);
		}

		
		//--------------------------------------------------------------------
		// Protected methods
		//--------------------------------------------------------------------
		
		/**
		 * Override this method in concrete class to implement 
		 * onLoad() execution. 
		 * 
		 * @param preferences	PXPreferences owner
		 * 
		 * @langversion 3.0
		 * @playerversion Flash 10
		 */
		protected function onLoad(preferences : PXPreferences) : void
		{
			var msg : String = "onLoad(" + preferences.id + ") must be implemented in concrete class.";
			throw new PXUnimplementedMethodException(msg, this);
		}

		/**
		 * Override this method in concrete class to implement 
		 * onSave() execution. 
		 * 
		 * @param	preferences	PXPreferences owner
		 * @param	data		Raw data to save
		 * 
		 * @langversion 3.0
		 * @playerversion Flash 10
		 */
		protected function onSave(preferences : PXPreferences, data : Object) : void
		{
			var msg : String = "onSave(" + preferences.id + "," + data + ") must be implemented in concrete class.";
			throw new PXUnimplementedMethodException(msg, this);
		}

		
		//--------------------------------------------------------------------
		// Private methods
		//--------------------------------------------------------------------
		
		/** @private */
		function PXAbstractStrategy()
		{
		}		
	}
}
