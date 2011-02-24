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
package net.pixlib.events 
{
	import net.pixlib.exceptions.PXIllegalArgumentException;

	import flash.utils.getQualifiedClassName;

	/**
	 * An <code>PXEventChannel</code> object defines a communication
	 * channel in the <code>PXChannelBroadcaster</code>. 
	 *  
	 * @langversion 3.0
	 * @playerversion Flash 10
	 * 
	 * @author 	Francis Bourre
	 * @see		ChannelBroadcaster
	 */
	public class PXEventChannel 
	{
		/**
		 * @private
		 */
		private var _sChannelName : String;
		
		/**
		 * Creates a new event channel with the passed-in channel name.
		 * <p>
		 * Several channel can have the same name, as the channel broadcaster
		 * use the instance of the class as key.
		 * </p>
		 * @param	channelName	name of this channel
		 * 
		 * @langversion 3.0
		 * @playerversion Flash 10
		 */
		public function PXEventChannel( channelName : String = null )
		{
			_sChannelName = channelName ? channelName : getQualifiedClassName(this);

			if ( _sChannelName == "EventChannel" )
			{
				throw new PXIllegalArgumentException("EventChannel must have a name, or be extended by another class", this);
			}
		}

		/**
		 * Returns the string representation of this object.
		 * 
		 * @return	the string representation of this object.
		 * 
		 * @langversion 3.0
		 * @playerversion Flash 10
		 */
		public function toString() : String
		{
			return _sChannelName;
		}
	}
}