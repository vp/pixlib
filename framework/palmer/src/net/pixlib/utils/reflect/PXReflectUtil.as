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
package net.pixlib.utils.reflect
{
	/**
	 * @author Romain Ecarnot
	 */
	final public class PXReflectUtil
	{
		/**
		 * @private
		 * 
		 * @langversion 3.0
		 * @playerversion Flash 10
		 */
		public static function bindProperties(target : Object, properties : Object, inheritance : Boolean = true) : void
		{
			var info : PXClassInfo = PXClassInfo.describe(target);
			var targetProperties : Vector.<String> = new Vector.<String>();
			
			for each (var property : PXPropertyInfo in info.getPropertyList(PXClassInfo.FACTORY_FILTER, inheritance)) 
			{
				targetProperties.push(property.name);
			}
			for each (var accessor : PXAccessorInfo in info.getAccessorList(PXClassInfo.FACTORY_FILTER, inheritance)) 
			{
				if(accessor.type != PXAccessorInfo.READONLY) targetProperties.push(accessor.name);
			}
			
			var len : uint = targetProperties.length;
			var name : String;
			
			for(var i : uint = 0;i < len;i++)
			{
				name = targetProperties[i];
				
				if(properties.hasOwnProperty(name))
				{
					target[name] = properties[name];
				}
			}
		}
	}
}
