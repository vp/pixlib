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
	import net.pixlib.exceptions.PXIllegalArgumentException;
	import net.pixlib.exceptions.PXIllegalStateException;
	
	import flash.utils.ByteArray;
	import flash.utils.Endian;


	/**
	 * The PXMOLanguageBundle class use MO file content as bundle content.
	 * 
	 * @author Romain Ecarnot
	 * 
	 * @langversion 3.0
	 * @playerversion Flash 10
	 */
	public class PXMOLanguageBundle extends PXLanguageBundle
	{
		// --------------------------------------------------------------------
		// Private properties
		// --------------------------------------------------------------------

		private static const BE : uint = 3725722773;

		private static const LE : uint = 2500072158;


		// --------------------------------------------------------------------
		// Public properties
		// --------------------------------------------------------------------

		/** @private */
		final override public function set content(data : Object) : void
		{
			super.content = parse(data as ByteArray);
		}

		
		// --------------------------------------------------------------------
		// Public API
		// --------------------------------------------------------------------

		/**
		 * Creates new instance.
		 * 
		 * @param data 			PO file content
		 * @param bundleID		Language bundle ID
		 * @param keyAttribute	XML attribute name for key identifier
		 * 
		 * @langversion 3.0
		 * @playerversion Flash 10
		 */
		public function PXMOLanguageBundle(language : String, data : ByteArray = null, bundleID : String = ID)
		{
			super(language, data ? parse(data) : null, bundleID);
		}
		
		/**
		 * @inheritDoc
		 */
		final override public function getResource(key : String) : String
		{
			if(content.hasOwnProperty(key)) return content[key];
			
			return null;
		}


		// --------------------------------------------------------------------
		// Protected methods
		// --------------------------------------------------------------------

		/**
		 * @private
		 */
		protected function parse(byte : ByteArray) : Object
		{
			var obj : Object = {};
			var lastk : String;
			var k : String;
			var masteridx : Number;
			var transidx : Number;
			var msgcount : Number;
			var version : Number;
			var buflen : Number = byte.bytesAvailable;
			var magic : Number = byte.readUnsignedInt();
			if (magic == BE)
			{
				byte.endian = Endian.BIG_ENDIAN;
			}
			else if (magic == LE)
			{
				byte.endian = Endian.LITTLE_ENDIAN;
			}
			else
			{
				throw new PXIllegalArgumentException("Invalid file", this);
				return null;
			}
			
			version = byte.readUnsignedInt();
			msgcount = byte.readUnsignedInt();
			masteridx = byte.readUnsignedInt();
			transidx = byte.readUnsignedInt();

			var mlen : Number;
			var moff : Number;
			var mend : Number;
			var tlen : Number;
			var toff : Number;
			var msg : String;
			var tmsg : String;
			var tend : Number;
			var items : Array;
			var item : String;
			
			for (var i : Number = 0; i < msgcount; i++)
			{
				byte.position = masteridx;
				mlen = byte.readUnsignedInt();
				moff = byte.readUnsignedInt();
				mend = moff + mlen;
				byte.position = transidx;
				tlen = byte.readUnsignedInt();
				toff = byte.readUnsignedInt();
				tend = toff + tlen;
				if (mend < buflen && tend < buflen)
				{
					byte.position = moff;
					msg = byte.readUTFBytes(mend - moff);
					byte.position = toff;
					tmsg = byte.readUTFBytes(tend - toff);
					
					obj[msg] = tmsg;
				}
				else
				{
					throw new PXIllegalStateException("File is corrupt", this);
				}
				if (mlen == 0)
				{
					lastk = k = null;
					items = tmsg.split("\n");
					for (var a : uint = 0; a < items.length; a++)
					{
						item = items[a];
						if (item == "")
						{
							continue;
						}
					}
				}
				byte.position = 0;
				masteridx += 8;
				transidx += 8;
			}
			
			return obj;
		}
	}
}

internal class POItem
{
	public var id : String;

	public var value : String;
}
