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
package net.pixlib.share
{
	import net.pixlib.core.PXValueObject;

	/**
	 * The PXSharingOptions class allows to add additional properties for 
	 * a sharing request.
	 * 
	 * <p>This class is dynalic to allow custom property setting.</p>
	 * 
	 * @langversion 3.0
	 * @playerversion Flash 10
	 * 
	 * @author Romain Ecarnot
	 */
	dynamic public class PXSharingOptions implements PXValueObject
	{
		/**
		 * More text content. (Orkut platform or Email sharing for example)
		 */
		public var message : String = null;
		
		/**
		 * Thumbnail to attach to your sharing post.
		 * (Orkut platform for example)
		 */
		public var thumbnail : String = null;
	}
}
