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
package net.pixlib.key
{
	import net.pixlib.collections.PXHashMap;
	import net.pixlib.commands.PXCommand;
	import net.pixlib.core.PXApplication;
	import net.pixlib.core.PXCoreFactory;
	import net.pixlib.events.PXEventBroadcaster;
	import net.pixlib.log.PXDebug;
	import net.pixlib.log.PXStringifier;
	import net.pixlib.utils.PXArrayUtils;

	import flash.events.Event;
	import flash.events.KeyboardEvent;
	import flash.utils.clearInterval;
	import flash.utils.getQualifiedClassName;

	/**
	 * Manages and stores PXKeyShortcut references.
	 * 
	 * <p>PXKeyBundle can be used separately or in with the PXKeyBundleManager 
	 * manager class.</p>
	 * 
	 * @example
	 * <listing>
	 * 
	 * package
	 * {
	 * 	import net.pixlib.commands.PXDelegate;
	 * 	import net.pixlib.core.PXBaseDocument;
	 * 	import net.pixlib.key.PXKey;
	 * 	import net.pixlib.key.PXKeyBundle;
	 * 	import net.pixlib.key.PXKeyShortcutEvent;
	 * 	import net.pixlib.log.PXDebug;
	 * 	import net.pixlib.log.PXTraceLayout;
	 * 	import net.pixlib.log.addLogListener;
	 * 
	 * 	public class Sample extends PXBaseDocument
	 * 	{
	 * 		override protected function onDocumentReady() : void
	 * 		{
	 * 			addLogListener(PXTraceLayout.getInstance());
	 * 
	 * 			var bundle : PXKeyBundle = new PXKeyBundle("UserPanel");
	 * 			bundle.pushCommand(new PXDelegate(_test), PXKey.Y);
	 * 			bundle.pushCommand(new PXDelegate(_test), PXKey.CONTROL, PXKey.Y);
	 * 			bundle.load();
	 * 
	 * 			bundle.fire(PXKey.Y);
	 * 		}
	 * 		
	 * 		private function _test(event : PXKeyShortcutEvent) : void
	 * 		{
	 * 			PXDebug.DEBUG("Activated " + event.shortcut, this);
	 * 		}
	 * 	}
	 * }
	 * </listing>
	 * 
	 * @see PXKeyShortcut
	 * @see PXKeyBundleManager
	 * 
	 * @langversion 3.0
	 * @playerversion Flash 10
	 * 
	 * @author Romain Ecarnot
	 */
	public class PXKeyBundle
	{
		// --------------------------------------------------------------------
		// Private properties
		// --------------------------------------------------------------------

		/**
		 * @private
		 */
		private var _id : String;

		/**
		 * @private
		 */
		private var _activated : Boolean;

		/**
		 * @private
		 */
		private var _broadcaster : PXEventBroadcaster;

		/**
		 * @private
		 */
		private var _mEventList : PXHashMap;

		/**
		 * @private
		 */
		private var _mShortcutList : PXHashMap;

		/**
		 * @private
		 */
		private var _keyDownList : Array;

		/**
		 * @private
		 */
		private var _isPending : Boolean;

		/**
		 * @private
		 */
		private var _isPendingCombo : Boolean;

		/**
		 * @private
		 */
		private var _pendingInterval : Number;


		// --------------------------------------------------------------------
		// Public properties
		// --------------------------------------------------------------------

		/**
		 * Defines if we listen the <code>KeyUp</code> event or not.
		 * 
		 * <p>Key combination ( combo ) are not available if 
		 * listenKeyUpEvent is <code>true</code></p>
		 * 
		 * @default false
		 * 
		 * @langversion 3.0
		 * @playerversion Flash 10
		 */
		public var listenKeyUpEvent : Boolean = false;


		/** 
		 * Bundle's identifier.
		 * 
		 * @langversion 3.0
		 * @playerversion Flash 10
		 */
		public function get name() : String
		{
			return _id;
		}


		// --------------------------------------------------------------------
		// Public API
		// --------------------------------------------------------------------

		/**
		 * Creates a new instance.
		 * 
		 * @param name	Bundle's identifier
		 * 
		 * @langversion 3.0
		 * @playerversion Flash 10
		 */
		public function PXKeyBundle(bundleName : String)
		{
			_id = bundleName;
			_broadcaster = new PXEventBroadcaster(this);
			_broadcaster.addListener(this);
			_mEventList = new PXHashMap();
			_mShortcutList = new PXHashMap();
			_keyDownList = new Array();
			_isPending = false;
			_isPendingCombo = false;
			listenKeyUpEvent = false;
			_activated = false;
		}

		/**
		 * Loads bundle.
		 * 
		 * <p>All stored shortcuts become active.</p>
		 * 
		 * @langversion 3.0
		 * @playerversion Flash 10
		 */
		public function load() : void
		{
			if ( !_activated )
			{
				_activated = true;
				_toggleKeyEventListener(true);

				_keyDownList = [];
			}
		}

		/**
		 * Unloads bundle.
		 * 
		 * <p>All stored shortcuts become inactive.</p>
		 * 
		 * @langversion 3.0
		 * @playerversion Flash 10
		 */
		public function unload() : void
		{
			if ( _activated )
			{
				_activated = false;
				_toggleKeyEventListener(false);

				_keyDownList = [];
			}
		}

		/**
		 * Adds command as shortcut listener.
		 * 
		 * @example
		 * <listing>
		 * 
		 *  var bundle : PXKeyBundle = new PXKeyBundle("UserPanel");
		 *  bundle.pushCommand( new PXDelegate ( _test ), PXKey.Y );
		 *  bundle.pushCommand( new PXDelegate ( _test ), PXKey.CONTROL, PXKey.Y );
		 *  bundle.pushCommand( new PXDelegate ( _test ), new PXKeyShortcut( PXKey.X ) );
		 *  bundle.load(); 
		 * </listing>
		 * 
		 * @param command	PXCommand instance
		 * @param key		PXKeyShortcut to listen
		 * @param rest		(optional) PXKeyShortcut combination
		 * 
		 * @return	The created PXKeyShortcut 
		 * 
		 * @langversion 3.0
		 * @playerversion Flash 10
		 */
		public function pushCommand(command : PXCommand, key : PXKeyShortcut, ...rest) : PXKeyShortcut
		{
			var storedKey : PXKeyShortcut = key;

			if ( rest.length > 0 )
			{
				storedKey = _createShortcutFromCombo([key].concat(rest));
			}

			_mShortcutList.put(storedKey.combo, storedKey);
			_mEventList.put(storedKey.combo, command);

			return storedKey;
		}

		/**
		 * Removes shortcut from bundle.
		 * 
		 * @example
		 * <listing>
		 * 
		 *  bundle.remove( Key.Y );
		 *  bundle.remove( Key.CONTROL, Key.Y );
		 *  bundle.remove( key );
		 * </listing>
		 * 
		 * @param key	PXKeyShortcut to listen
		 * @param rest	PXKeyShortcut combination to remove
		 * 
		 * @return	Removed PXKeyShortcut
		 * 
		 * @langversion 3.0
		 * @playerversion Flash 10
		 */
		public function remove(key : PXKeyShortcut, ...rest) : PXKeyShortcut
		{
			var storedKey : PXKeyShortcut = key;

			if ( rest.length > 0 )
			{
				storedKey = _createShortcutFromCombo([key].concat(rest));
			}

			_mEventList.remove(storedKey.combo);
			if ( _mEventList.empty ) _toggleKeyEventListener(false);

			return _mShortcutList.remove(storedKey.combo) as PXKeyShortcut;
		}

		/**
		 * Clears registered shortcuts list.
		 * 
		 * @langversion 3.0
		 * @playerversion Flash 10
		 */
		public function clear() : void
		{
			_mEventList.clear();
			_mShortcutList.clear();

			_toggleKeyEventListener(false);
		}

		/**
		 * Broadcasts specific shortcut.
		 * 
		 * @example
		 * <listing>
		 * 
		 *  var combo : PXKeyShortcut = new PXKeyShortcut(PXKey.CONTROL, PXKey.D);
		 * 
		 *  var bundle : PXKeyBundle = new PXKeyBundle("UserPanel");
		 *  bundle.pushCommand(new PXDelegate( _test ), combo );
		 *  bundle.pushCommand(new PXDelegate( _test ), PXKey.CONTROL, PXKey.D);
		 * 
		 *  // Fires shortcut
		 *  bundle.fire( combo );
		 * 
		 *  // Fire the same shortcut using key combination
		 *  bundle.fire(PXKey.CONTROL, PXKey.D); 
		 * </listing>
		 * 
		 * @param key	PXShortcut to activate
		 * @param rest	PXShortcut key combination 
		 * 
		 * @langversion 3.0
		 * @playerversion Flash 10
		 */
		public function fire(key : PXKeyShortcut, ...rest) : void
		{
			var keyType : String = "";

			if ( rest.length > 0 )
			{
				rest = [key].concat(rest);

				var l : int = rest.length;

				for ( var i : int = 0;i < l; i += 1 )
				{
					var next : PXKeyShortcut = rest[ i ] as PXKeyShortcut;
					keyType += next.combo;

					if ( i < l - 1 ) keyType += PXKeyShortcut.LIMITER;
				}
			}
			else keyType = key.combo;

			_fireEvent(keyType, NaN, null);
		}

		/**
		 * Returns string representation.
		 * 
		 * @return string representation of instance
		 * 
		 * @langversion 3.0
		 * @playerversion Flash 10
		 */
		public function toString() : String
		{
			return PXStringifier.process(this) + "[" + _id + "]";
		}


		// --------------------------------------------------------------------
		// Private implementations
		// --------------------------------------------------------------------

		/** @private */
		private function _createShortcutFromCombo(keyList : Array) : PXKeyShortcut
		{
			return PXCoreFactory.getInstance().buildInstance(getQualifiedClassName(PXKeyShortcut), keyList) as PXKeyShortcut;
		}

		/** @private */
		private function _toggleKeyEventListener(enabled : Boolean = false) : void
		{
			if ( enabled && _activated )
			{
				PXApplication.getInstance().root.stage.addEventListener(KeyboardEvent.KEY_DOWN, _keyDownHandler);
				PXApplication.getInstance().root.stage.addEventListener(KeyboardEvent.KEY_UP, _keyUpHandler);
			}
			else
			{
				PXApplication.getInstance().root.stage.removeEventListener(KeyboardEvent.KEY_DOWN, _keyDownHandler);
				PXApplication.getInstance().root.stage.removeEventListener(KeyboardEvent.KEY_UP, _keyUpHandler);
			}
		}

		/** @private */
		private function _keyDownHandler(event : KeyboardEvent) : void
		{
			if ( !listenKeyUpEvent )
			{
				var code : uint = event.keyCode;
				var shortcut : PXKeyShortcut = PXKeyShortcut.getStruct(code);

				if ( !PXArrayUtils.contains(shortcut.combo, _keyDownList) )
				{
					_keyDownList.push(shortcut.combo);
				}

				var key : String = _keyDownList.join(PXKeyShortcut.LIMITER);

				if ( _mShortcutList.containsKey(key) )
				{
					var myKey : PXKeyShortcut = _mShortcutList.get(key);

					if ( !_isPendingCombo )
					{
						_fireEvent(myKey.combo, NaN, event);
						_isPendingCombo = true;

						if (!myKey.repeatable)
						{
							_stopPendingCombo();
							_fixMnemonic(event);
							_isPendingCombo = true;
						}
					}
					else
					{
						if (myKey.repeatable)
						{
							_fireEvent(myKey.combo, NaN, event);
						}
					}
				}
				else
				{
					// if( !_isPending )
					// {
					// _isPending = true;
					// _fireEvent(shortcut.combo, code, event);
					// clearInterval(_pendingInterval);
					// _pendingInterval = setInterval(_stopPending, shortcut.delay);
					// }
				}
			}
		}

		/** @private */
		private function _keyUpHandler(event : KeyboardEvent) : void
		{
			var code : uint = event.keyCode;

			try
			{
				PXArrayUtils.remove(PXKeyShortcut.getStruct(code).combo, _keyDownList);

				if ( !listenKeyUpEvent )
				{
					_stopPending();
					if ( _isPendingCombo )
					{
						_stopPendingCombo();

						_fixMnemonic(event);
					}
				}
				else _prepareEvent(code, event);
			}
			catch(e : Error)
			{
				PXDebug.ERROR(e.message, this);
			}
		}

		/** @private */
		private function _fixMnemonic(event : KeyboardEvent) : void
		{
			if (event.ctrlKey)
			{
				if ( !PXArrayUtils.contains(PXKey.CONTROL.combo, _keyDownList) ) _keyDownList.push(PXKey.CONTROL.combo);
			}

			if (event.shiftKey)
			{
				if ( !PXArrayUtils.contains(PXKey.SHIFT.combo, _keyDownList) ) _keyDownList.push(PXKey.SHIFT.combo);
			}

			try
			{
				if (event["commandKey"])
				{
					if ( !PXArrayUtils.contains(PXKey.COMMAND.combo, _keyDownList) ) _keyDownList.push(PXKey.COMMAND.combo);
				}
			}
			catch(e : Error)
			{
			}
		}

		/** @private */
		private function _prepareEvent(code : uint, event : KeyboardEvent) : void
		{
			var combo : String = PXKeyShortcut.getStruct(code).combo;

			if ( _mShortcutList.containsKey(combo))
			{
				_fireEvent(combo, code, event);
			}
		}

		/** @private */
		private function _fireEvent(comboID : String, code : uint, event : KeyboardEvent = null) : void
		{
			if ( !_activated ) return;

			if ( _mEventList.containsKey(comboID) )
			{
				var e : PXKeyShortcutEvent = new PXKeyShortcutEvent(_mShortcutList.get(comboID), this);
				e.keyCode = code;

				if ( event != null )
				{
					e.charCode = event.charCode;
					e.altKey = event.altKey;
					e.ctrlKey = event.ctrlKey;
					e.shiftKey = event.shiftKey;
					e.keyLocation = event.keyLocation;
				}

				_broadcaster.broadcastEvent(e);
			}
		}

		/**
		 * @private
		 * Release key down repetition locker.
		 */
		private function _stopPending() : void
		{
			clearInterval(_pendingInterval);
			_isPending = false;
		}

		/**
		 * @private
		 * Release combo key down repetition locker.
		 */
		private function _stopPendingCombo() : void
		{
			_keyDownList = new Array();

			_isPendingCombo = false;
		}

		/**
		 * @private
		 * Process event handling
		 */
		final public function handleEvent(event : Event) : void
		{
			var type : String = event.type.toString();

			if ( _mEventList.containsKey(type) )
			{
				var o : Object = _mEventList.get(type);

				if ( o is PXCommand ) o.execute(event);
			}
		}
	}
}