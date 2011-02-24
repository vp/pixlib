/* * Copyright the original author or authors. *  * Licensed under the MOZILLA PUBLIC LICENSE, Version 1.1 (the "License"); * you may not use this file except in compliance with the License. * You may obtain a copy of the License at *  *      http://www.mozilla.org/MPL/MPL-1.1.html *  * Unless required by applicable law or agreed to in writing, software * distributed under the License is distributed on an "AS IS" BASIS, * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied. * See the License for the specific language governing permissions and * limitations under the License. */package net.pixlib.encoding{	import net.pixlib.display.css.PXCSS;	import net.pixlib.exceptions.PXIllegalArgumentException;	import net.pixlib.log.PXStringifier;	import flash.text.StyleSheet;	
	/**	 * The PXCSSDeserializer class deserialize content to build CSS instance.	 * 	 * @see	net.pixlib.css.PXCSS PXCSS class	 * 	 * @langversion 3.0	 * @playerversion Flash 10	 * 	 * @author Romain Ecarnot	 */
	final public class PXCSSDeserializer implements PXDeserializer
	{
		// --------------------------------------------------------------------
		// Public API
		// --------------------------------------------------------------------
		/**		 * Creates instance.		 * 		 * @langversion 3.0		 * @playerversion Flash 10		 */
		public function PXCSSDeserializer()
		{
		}

		/**		 * Deserializes passed-in serializedContent and returns a CSS instance 		 * using deserialization result.		 * 		 * @param serializedContent Content to deserialize		 * @param target			(optional) Object to store deserialization 		 * 							result.		 * @param key				(optional) Registration identifier		 * 		 * @return serializedContent as a CSS instance if deserialization 		 * process is success.		 * 		 * @throws	net.pixlib.exceptions.IllegalArgumentException The serializedContent 		 * 			is not a compliant StyleSheet source.		 * 					 * @langversion 3.0		 * @playerversion Flash 10		 */
		public function deserialize(serializedContent : Object, target : Object = null, key : String = null) : Object
		{
			try
			{
				var sheet : StyleSheet = new StyleSheet(); 				sheet.parseCSS(serializedContent as String); 				var css : PXCSS = new PXCSS(key, sheet, null, true); 				return css; 
			}
			catch( e : Error )
			{
				throw new PXIllegalArgumentException("deserialize() error. Content is not CSS compliant", this);
			}
			return null;
		}

		/**		 * Returns string represenation of this instance.		 * 		 * @return string represenation of this instance.		 * 		 * @langversion 3.0		 * @playerversion Flash 10		 */
		public function toString() : String
		{
			return PXStringifier.process(this);
		}
	}
}