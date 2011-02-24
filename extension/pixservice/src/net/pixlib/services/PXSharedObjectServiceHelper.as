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
package net.pixlib.services 
{
	import net.pixlib.core.PXValueObject;

	/**
	 * Service helper to store <strong>SharedObject</strong> connection properties
	 * 
	 * @langversion 3.0
	 * @playerversion Flash 10
	 * 
	 * @author Romain Ecarnot
	 * @author Francis Bourre
	 */
	public class PXSharedObjectServiceHelper implements PXValueObject 
	{
		public var name : String;
		public var localPath : String;
		public var secure : Boolean;
		
		/**
		 * @param	name		The name of the object.
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
		public function PXSharedObjectServiceHelper( name : String, localPath : String = "/", secure : Boolean = false ) 
		{
			this.name = name;			this.localPath = localPath;			this.secure = secure;
		}
	}
}
