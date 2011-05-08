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
package net.pixlib.tms.bundles 
{
	import net.pixlib.utils.PXStringUtils;

	import mx.utils.StringUtil;

	import flash.utils.Dictionary;
	
	
	/**
	 * The PXPOLanguageBundle class use PO file content as bundle content.
	 * 
	 * @author Romain Ecarnot
	 * 
	 * @langversion 3.0
	 * @playerversion Flash 10
	 */
	public class PXPOLanguageBundle extends PXLanguageBundle
	{
		//--------------------------------------------------------------------
		// Private properties
		//--------------------------------------------------------------------
		
		/** @private */
		private var _dico : Dictionary;
		
		/** @private */
		final override 
		public function set content( data : Object ) : void
		{
			super.content = parse(data.toString());
		}
		
		
		//--------------------------------------------------------------------
		// Public API
		//--------------------------------------------------------------------
		
		/**
		 * Creates new POLanguageBundle instance.
		 * 
		 * @param data 			PO file content
		 * @param bundleID		Language bundle ID
		 * @param keyAttribute	XML attribute name for key identifier
		 * 
		 * @langversion 3.0
	 	 * @playerversion Flash 10
		 */
		public function PXPOLanguageBundle(language : String, data : String = null, bundleID : String = ID)
		{
			super(language, data ? parse(data) : null, bundleID);
		}
		
		/**
		 * @inheritDoc
		 */
		final override public function getResource(key : String) : String
		{
			if(_dico[key]) return _dico[key];
			return null;
		}
		
		
		//--------------------------------------------------------------------
		// Protected methods
		//--------------------------------------------------------------------
			
		/**
		 * @private
		 */
		protected function parse(data : String) : Dictionary
		{
			data = PXStringUtils.replace(data, String.fromCharCode(13) + String.fromCharCode(10), "\n");
			data = PXStringUtils.replace(data, String.fromCharCode(10), "\n");
			
			_dico = new Dictionary();
			
			var lines : Array = data.split("\n");
			var props : Array = [];
			
			for (var i : int = 0; i < lines.length; i++)
			{
				line = lines[i];
				if(line.indexOf("#") != 0 && line.length > 0)
				{
					props.push(lines[i]);
				}
			}
			
			var len : uint = props.length;
			var line : String;
			var prop : Boolean = false;
			var value : Boolean = false;
			var items :  Array = [];
			var item : POItem;
			
			for (i = 0; i < len; i++)
			{
				line = props[i];
				
				if(line.indexOf("msgid") == 0)
				{
					item = new POItem();
					items.push(item);
					
					item.id = PXStringUtils.replace(line.substr(5), "\"", "");
					
					prop = true;
					value = false;
					continue;
				}
				
				if(line.indexOf("msgstr") == 0)
				{
					item.value = PXStringUtils.replace(line.substr(6), "\"", "");
					prop = false;
					value = true;
					continue;
				}
				
				if(prop) item.id += "\n" + PXStringUtils.replace(line, "\"", "");
				else if(value) item.value += "\n" + PXStringUtils.replace(line, "\"", "");
			}
			
			len = items.length;
			for(i = 0; i < len; i++)
			{
				item = items[i];
				item.id = PXStringUtils.replace(item.id, "\\n", "\n");
				item.id = StringUtil.trim(item.id);
				
				item.value = PXStringUtils.replace(item.value, "\\n", "\n");
				item.value = StringUtil.trim(item.value);
				
				_dico[item.id] = item.value;
			}
			
			items = []; items = null;
			lines = []; lines = null;
			props = null;
			
			return _dico;
		}
	}
}

internal class POItem
{
	public var id : String;
	public var value : String;
}
