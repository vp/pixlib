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
	import net.pixlib.log.PXStringifier;
	import net.pixlib.utils.PXStringUtils;

	import flash.ui.Keyboard;

	/**
	 * Keyboard shortcut structure definition.
	 * 
	 * @see PXKey
	 * @see PXKeyBundle
	 * 
	 * @langversion 3.0
	 * @playerversion Flash 10
	 * 
	 * @author Romain Ecarnot
	 */
	final public class PXKeyShortcut
	{
		// --------------------------------------------------------------------
		// Constants
		// --------------------------------------------------------------------

		/**
		 * @private
		 * Character definition for concatenation character.
		 * 
		 * @langversion 3.0
		 * @playerversion Flash 10
		 */
		public static const LIMITER : String = "|";


		// --------------------------------------------------------------------
		// Private properties
		// --------------------------------------------------------------------

		/**
		 * @private
		 */
		private static var _oKeyMap : PXHashMap;

		/**
		 * @private
		 */
		private static var _oCharMap : PXHashMap;

		/**
		 * @private
		 */
		private var _combo : String;

		/**
		 * @private
		 */
		private var _name : String;

		/**
		 * @private
		 */
		private var _repeatable : Boolean;


		// --------------------------------------------------------------------
		// Public properties
		// --------------------------------------------------------------------


		/** 
		 * Combo identifier.
		 * 
		 * @langversion 3.0
		 * @playerversion Flash 10
		 */
		public function get combo() : String
		{
			return _combo;
		}

		/**
		 * Returns key(s) structure name.
		 * 
		 * @langversion 3.0
		 * @playerversion Flash 10
		 */
		public function get name() : String
		{
			return _name;
		}

		/**
		 * Action repetition state.
		 * 
		 * @default false
		 * 
		 * @langversion 3.0
		 * @playerversion Flash 10
		 */
		public function get repeatable() : Boolean
		{
			return _repeatable;
		}

		/** @private */
		public function set repeatable(value : Boolean) : void
		{
			_repeatable = value;
		}


		// --------------------------------------------------------------------
		// Public API
		// --------------------------------------------------------------------

		/**
		 * Creates a new instance.
		 * 
		 * @example
		 * <listing>
		 * 
		 * 	new PXKeyShortcut( PXKey.A);
		 * 	new PXKeyShortcut( PXKey.CONTROL, PXKey.A);
		 * </listing>
		 * 
		 * @param key 	PXKeyShortcut constants
		 * @param rest 	(optional) others key constants to build combo
		 * 
		 * @langversion 3.0
		 * @playerversion Flash 10
		 */
		public function PXKeyShortcut(key : PXKeyShortcut, ...rest)
		{
			_repeatable = false;

			if (key) _buildShortcutIdentifiers([key].concat(rest.length > 0 ? rest : []));
		}

		/**
		 * Returns the string representation of instance.
		 * 
		 * @return The string representation of instance.
		 * 
		 * @langversion 3.0
		 * @playerversion Flash 10
		 */
		public function toString() : String
		{
			return PXStringifier.process(this) + "[" + name + "]";
		}


		// --------------------------------------------------------------------
		// Private implementations
		// --------------------------------------------------------------------

		/**
		 * @private
		 */
		internal static function buildShortcut(keyName : String) : PXKeyShortcut
		{
			var sc : PXKeyShortcut = new PXKeyShortcut(null);
			sc._name = keyName;
			sc._combo = keyName;

			return sc;
		}

		/**
		 * @private
		 * 
		 * Returns PXKeyShortcut instance defined 
		 * by passed-in <code>code</code>
		 * 
		 * @param code Key code (or key sequence id) to search.
		 * 
		 * @langversion 3.0
		 * @playerversion Flash 10
		 */
		internal static function getStruct(code : uint) : PXKeyShortcut
		{
			if (!_oKeyMap) _initKeyMap();

			return _oKeyMap.get(code) as PXKeyShortcut;
		}

		/**
		 * @private
		 * 
		 * Returns PXKeyShortcut instance defined by 
		 * passed-in <code>char</code> string.
		 */
		internal static function getCharStruct(char : String) : PXKeyShortcut
		{
			if (!_oCharMap) _initCharMap();

			return _oCharMap.get(char) as PXKeyShortcut;
		}

		/**
		 * @private
		 * 
		 * Returns key code from passed-in <code>key</code> instance.
		 * 
		 * @param key PXKeyShortcut instance
		 * @return Key code
		 * 
		 * @langversion 3.0
		 * @playerversion Flash 10
		 */
		internal static function getCodeFromStruct(key : PXKeyShortcut) : uint
		{
			var values : Array = _oKeyMap.values;
			var l : int = values.length;
			while (--l > 0) if ( values[l] == key ) return l;
			return NaN;
		}

		/**
		 * @private
		 */
		private function _buildShortcutIdentifiers(keyList : Array) : void
		{
			var l : int = keyList.length;
			var c : String = "";
			var comboName : String = "";

			for ( var i : int = 0;i < l; i += 1 )
			{
				var next : PXKeyShortcut = keyList[ i ] as PXKeyShortcut;
				c += next.name;
				comboName += PXStringUtils.uppercaseFirst(next.name);

				if ( i < l - 1 )
				{
					c += LIMITER;
					comboName += "+";
				}
			}

			_combo = c;
			_name = comboName;
		}

		/**
		 * @private
		 */
		private static function _initKeyMap() : void
		{
			_oKeyMap = new PXHashMap();
			_oKeyMap.put(65, PXKey.A);
			_oKeyMap.put(66, PXKey.B);
			_oKeyMap.put(67, PXKey.C);
			_oKeyMap.put(68, PXKey.D);
			_oKeyMap.put(69, PXKey.E);
			_oKeyMap.put(70, PXKey.F);
			_oKeyMap.put(71, PXKey.G);
			_oKeyMap.put(72, PXKey.H);
			_oKeyMap.put(73, PXKey.I);
			_oKeyMap.put(74, PXKey.J);
			_oKeyMap.put(75, PXKey.K);
			_oKeyMap.put(76, PXKey.L);
			_oKeyMap.put(77, PXKey.M);
			_oKeyMap.put(78, PXKey.N);
			_oKeyMap.put(79, PXKey.O);
			_oKeyMap.put(80, PXKey.P);
			_oKeyMap.put(81, PXKey.Q);
			_oKeyMap.put(82, PXKey.R);
			_oKeyMap.put(83, PXKey.S);
			_oKeyMap.put(84, PXKey.T);
			_oKeyMap.put(85, PXKey.U);
			_oKeyMap.put(86, PXKey.V);
			_oKeyMap.put(87, PXKey.W);
			_oKeyMap.put(88, PXKey.X);
			_oKeyMap.put(89, PXKey.Y);
			_oKeyMap.put(90, PXKey.Z);

			_oKeyMap.put(48, PXKey.NUM_0);
			_oKeyMap.put(49, PXKey.NUM_1);
			_oKeyMap.put(50, PXKey.NUM_2);
			_oKeyMap.put(51, PXKey.NUM_3);
			_oKeyMap.put(52, PXKey.NUM_4);
			_oKeyMap.put(53, PXKey.NUM_5);
			_oKeyMap.put(54, PXKey.NUM_6);
			_oKeyMap.put(55, PXKey.NUM_7);
			_oKeyMap.put(56, PXKey.NUM_8);
			_oKeyMap.put(57, PXKey.NUM_9);

			_oKeyMap.put(Keyboard.NUMPAD_0, PXKey.PAD0);
			_oKeyMap.put(Keyboard.NUMPAD_1, PXKey.PAD1);
			_oKeyMap.put(Keyboard.NUMPAD_2, PXKey.PAD2);
			_oKeyMap.put(Keyboard.NUMPAD_3, PXKey.PAD3);
			_oKeyMap.put(Keyboard.NUMPAD_4, PXKey.PAD4);
			_oKeyMap.put(Keyboard.NUMPAD_5, PXKey.PAD5);
			_oKeyMap.put(Keyboard.NUMPAD_6, PXKey.PAD6);
			_oKeyMap.put(Keyboard.NUMPAD_7, PXKey.PAD7);
			_oKeyMap.put(Keyboard.NUMPAD_8, PXKey.PAD8);
			_oKeyMap.put(Keyboard.NUMPAD_9, PXKey.PAD9);

			_oKeyMap.put(Keyboard.NUMPAD_MULTIPLY, PXKey.MULTIPLY);
			_oKeyMap.put(Keyboard.NUMPAD_ADD, PXKey.ADD);
			_oKeyMap.put(Keyboard.NUMPAD_SUBTRACT, PXKey.SUBSTRACT);
			_oKeyMap.put(Keyboard.NUMPAD_DECIMAL, PXKey.DECIMAL);
			_oKeyMap.put(Keyboard.NUMPAD_DIVIDE, PXKey.DIVIDE);

			_oKeyMap.put(Keyboard.F1, PXKey.F1);
			_oKeyMap.put(Keyboard.F2, PXKey.F2);
			_oKeyMap.put(Keyboard.F3, PXKey.F3);
			_oKeyMap.put(Keyboard.F4, PXKey.F4);
			_oKeyMap.put(Keyboard.F5, PXKey.F5);
			_oKeyMap.put(Keyboard.F6, PXKey.F6);
			_oKeyMap.put(Keyboard.F7, PXKey.F7);
			_oKeyMap.put(Keyboard.F8, PXKey.F8);
			_oKeyMap.put(Keyboard.F9, PXKey.F9);
			_oKeyMap.put(Keyboard.F10, PXKey.F10);
			_oKeyMap.put(Keyboard.F11, PXKey.F11);
			_oKeyMap.put(Keyboard.F12, PXKey.F12);
			_oKeyMap.put(Keyboard.F13, PXKey.F13);
			_oKeyMap.put(Keyboard.F14, PXKey.F14);
			_oKeyMap.put(Keyboard.F15, PXKey.F15);

			_oKeyMap.put(Keyboard.BACKSPACE, PXKey.BACKSPACE);
			_oKeyMap.put(Keyboard.CAPS_LOCK, PXKey.CAPSLOCK);
			_oKeyMap.put(Keyboard.CONTROL, PXKey.CONTROL);
			_oKeyMap.put(15, PXKey.COMMAND);
			_oKeyMap.put(Keyboard.DELETE, PXKey.DELETEKEY);
			_oKeyMap.put(Keyboard.DOWN, PXKey.DOWN);
			_oKeyMap.put(Keyboard.END, PXKey.END);
			_oKeyMap.put(Keyboard.ENTER, PXKey.ENTER);
			_oKeyMap.put(Keyboard.ESCAPE, PXKey.ESCAPE);
			_oKeyMap.put(Keyboard.HOME, PXKey.HOME);
			_oKeyMap.put(Keyboard.INSERT, PXKey.INSERT);
			_oKeyMap.put(Keyboard.LEFT, PXKey.LEFT);
			_oKeyMap.put(Keyboard.PAGE_DOWN, PXKey.PGDN);
			_oKeyMap.put(Keyboard.PAGE_UP, PXKey.PGUP);
			_oKeyMap.put(Keyboard.RIGHT, PXKey.RIGHT);
			_oKeyMap.put(Keyboard.SHIFT, PXKey.SHIFT);
			_oKeyMap.put(Keyboard.SPACE, PXKey.SPACE);
			_oKeyMap.put(Keyboard.TAB, PXKey.TAB);
			_oKeyMap.put(Keyboard.UP, PXKey.UP);
		}

		/**
		 * @private
		 */
		private static function _initCharMap() : void
		{
			_oCharMap = new PXHashMap();
			_oCharMap.put("a", PXKey.A);
			_oCharMap.put("b", PXKey.B);
			_oCharMap.put("c", PXKey.C);
			_oCharMap.put("d", PXKey.D);
			_oCharMap.put("e", PXKey.E);
			_oCharMap.put("f", PXKey.F);
			_oCharMap.put("g", PXKey.G);
			_oCharMap.put("h", PXKey.H);
			_oCharMap.put("i", PXKey.I);
			_oCharMap.put("j", PXKey.J);
			_oCharMap.put("k", PXKey.K);
			_oCharMap.put("l", PXKey.L);
			_oCharMap.put("m", PXKey.M);
			_oCharMap.put("n", PXKey.N);
			_oCharMap.put("o", PXKey.O);
			_oCharMap.put("p", PXKey.P);
			_oCharMap.put("q", PXKey.Q);
			_oCharMap.put("r", PXKey.R);
			_oCharMap.put("s", PXKey.S);
			_oCharMap.put("t", PXKey.T);
			_oCharMap.put("u", PXKey.U);
			_oCharMap.put("v", PXKey.V);
			_oCharMap.put("w", PXKey.W);
			_oCharMap.put("x", PXKey.X);
			_oCharMap.put("y", PXKey.Y);
			_oCharMap.put("z", PXKey.Z);
			_oCharMap.put("0", PXKey.NUM_0);
			_oCharMap.put("1", PXKey.NUM_1);
			_oCharMap.put("2", PXKey.NUM_2);
			_oCharMap.put("3", PXKey.NUM_3);
			_oCharMap.put("4", PXKey.NUM_4);
			_oCharMap.put("5", PXKey.NUM_5);
			_oCharMap.put("6", PXKey.NUM_6);
			_oCharMap.put("7", PXKey.NUM_7);
			_oCharMap.put("8", PXKey.NUM_8);
			_oCharMap.put("9", PXKey.NUM_9);
		}
	}
}
