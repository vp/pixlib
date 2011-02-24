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
package net.pixlib.commands 
{
	import net.pixlib.events.PXCommandEvent;
	import net.pixlib.log.PXDebug;
	import net.pixlib.log.PXStringifier;
	import net.pixlib.transitions.PXRealTimeBeacon;
	import net.pixlib.transitions.PXTickEvent;
	import net.pixlib.transitions.PXTickListener;

	import flash.events.Event;

	/**
	 * The PXTimeOut class defines timeout of command.
	 * 
	 * @langversion 3.0
	 * @playerversion Flash 10
	 */
	public class PXTimeOut implements PXCommandListener, PXTickListener
	{
		protected var oCommand 	: PXCommand;
		protected var nElasped 	: uint;
		protected var nLimit 	: uint;
		protected var oBeacon 	: PXRealTimeBeacon;
		
		/**
		 * Return the delay to fire timeOut event.
		 * 
		 * @langversion 3.0
		 * @playerversion Flash 10
		 */
		public function get limit() : uint
		{
			return nLimit;	
		}
		
		/**
		 * Define delay to fire timeOut event.
		 * @param value	  delay to fire timeOut event.
		 * 
		 * @langversion 3.0
		 * @playerversion Flash 10
		 */
		public function set limit ( value : uint ) : void
		{
			if( !oCommand.running )
			{
				nLimit = isNaN( value ) ? 0 : value;

			} else
			{
				PXDebug.WARN("limit property is not writable while timeout's running.", this);
			}
		}
		
		/**
		 * Timeout PXCommand
		 * 
		 * @param command <code>PXCommand</code>.
		 * @param limit	  delay to fire timeOut event.
		 * 
		 * @langversion 3.0
		 * @playerversion Flash 10
		 */
		public function PXTimeOut ( command : PXCommand, limit : uint = 5000 )
		{
			this.oCommand 	= command;
			this.limit 		= limit;

			nElasped 		= 0;
			oBeacon 		= PXRealTimeBeacon.getInstance();
			
			this.oCommand.addCommandListener( this );
		} 

		/**
		 * @inheritDoc
		 */
		public function onTick ( event : Event = null ) : void
		{
			if(event) event.stopImmediatePropagation();
			
			if ( nLimit != 0 )
			{
				nElasped += ( event as PXTickEvent ).bias * oBeacon.speedFactor;
				if ( nElasped > nLimit ) oCommand.fireCommandEndEvent( );
			}
		}

		/**
		 * @inheritDoc
		 */
		public function toString() : String
		{
			return PXStringifier.process( this );
		}

		/**
		 * @inheritDoc
		 */
		public function fireCommandEndEvent() : void
		{
			oCommand.fireCommandEndEvent();
		}

		/**
		 * @inheritDoc
		 */
		public function onCommandStart ( event : PXCommandEvent ) : void
		{
			oBeacon.addListener( this );
			oBeacon.start();
		}

		/**
		 * @inheritDoc
		 */
		public function onCommandEnd ( event : PXCommandEvent ) : void
		{
			oBeacon.stop();
			oBeacon.removeListener( this );
		}
	}
}