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
package net.pixlib.transitions
{
	import net.pixlib.events.PXBasicEvent;
	import net.pixlib.log.PXStringifier;

	import flash.display.Shape;
	import flash.events.Event;
	import flash.events.EventDispatcher;


	/**
	 * The PXFPSBeacon class provides tick to its listeners based
	 * on the native <code>ENTER_FRAME</code> event. A <code>Shape</code>
	 * object is instanciated internally to provide this callback. By the
	 * way, the minimum time step for this beacon is subject to the flash
	 * player restrictions (playing in a browser or in a stand-alone player
	 * for example).
	 * <p>
	 * The <code>PXFPSBeacon</code> provides an access to a global instance
	 * of the class, concret <code>PXTickListener</code> may uses that instance
	 * by default when starting or stopping their animations.
	 * </p>
	 * 
	 * @langversion 3.0
	 * @playerversion Flash 10
	 * 
	 * @author	Cédric Néhémie
	 * @see		TickBeacon
	 */
	final public class PXFPSBeacon implements PXTickBeacon
	{
		/**
		 * @private
		 */
		static private var _oI : PXFPSBeacon;

		/**
		 * @private
		 */
		protected const sTickEventType : String = PXTickEvent.TICK;

		/**
		 * Shape object used to listen ENTER_FRAME event.
		 * 
		 * @langversion 3.0
		 * @playerversion Flash 10
		 */
		protected const oShape : Shape = new Shape();
		
		/**
		 * EventDispatcher used to broadcast internal event.
		 * 
		 * @langversion 3.0
		 * @playerversion Flash 10
		 */
		protected var oED : EventDispatcher;


		/**
		 * @inheritDoc 
		 */
		public function get playing() : Boolean
		{
			return oShape.hasEventListener(Event.ENTER_FRAME);
		}

		/**
		 * Provides an access to a global instance of the 
		 * <code>PXFPSBeacon</code> class. That doesn't mean
		 * that the PXFPSBeacon class is a singleton, it simplify
		 * the usage of that beacon into concret <code>PXTickListener</code>
		 * implementation, which would register to a PXFPSBeacon instance.
		 * 
		 * @return a singleton instance of the <code>PXFPSBeacon</code> class
		 * 
		 * @langversion 3.0
		 * @playerversion Flash 10
		 */
		static public function getInstance() : PXFPSBeacon
		{
			if ( !(PXFPSBeacon._oI is PXFPSBeacon) )
				PXFPSBeacon._oI = new PXFPSBeacon();
			return PXFPSBeacon._oI;
		}

		/**
		 * Stops and the delete the current global instance
		 * of the <code>PXFPSBeacon</code> class.
		 * 
		 * @langversion 3.0
		 * @playerversion Flash 10
		 */
		static public function release() : void
		{
			PXFPSBeacon._oI.stop();
			PXFPSBeacon._oI = null;
		}

		/**
		 * Creates a new instance.
		 * 
		 * @see #getInstance() for singleton access
		 * 
		 * @langversion 3.0
		 * @playerversion Flash 10
		 */
		public function PXFPSBeacon()
		{
			oED = new EventDispatcher();
		}
		
		/**
		 * @inheritDoc
		 */
		public function start() : void
		{
			if ( !playing ) oShape.addEventListener(Event.ENTER_FRAME, enterFrameHandler);
		}

		/**
		 * @inheritDoc
		 */
		public function stop() : void
		{
			if ( playing ) oShape.removeEventListener(Event.ENTER_FRAME, enterFrameHandler);
		}

		/**
		 * @inheritDoc
		 */
		public function addListener(listener : PXTickListener) : void
		{
			if ( !oED.hasEventListener(sTickEventType) ) start();
			oED.addEventListener(sTickEventType, listener.onTick, false, 0, true);
		}

		/**
		 * @inheritDoc
		 */
		public function removeListener(listener : PXTickListener) : void
		{
			oED.removeEventListener(sTickEventType, listener.onTick);
			if ( !oED.hasEventListener(sTickEventType) ) stop();
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
			return PXStringifier.process(this);
		}

		/**
		 * Handles the <code>ENTER_FRAME</code> from the internal
		 * <code>Shape</code> object, and dispatches <code>onTick</code>
		 * event to each listener.
		 * 
		 * @param	e	event dispatched by the Shape object property
		 * 
		 * @langversion 3.0
		 * @playerversion Flash 10
		 */
		protected function enterFrameHandler(e : Event = null) : void
		{
			var evt : PXBasicEvent = new PXBasicEvent(sTickEventType, this);
			oED.dispatchEvent(evt);
		}
	}
}