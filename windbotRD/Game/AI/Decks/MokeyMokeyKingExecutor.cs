using YGOSharp.OCGWrapper.Enums;
using System.Collections.Generic;
using System.Linq;
using WindBot;
using WindBot.Game;
using WindBot.Game.AI;
using System;

namespace WindBot.Game.AI.Decks
{
    [Deck("MokeyMokeyKing", "AI_MokeyMokeyKing")]
   
    public class MokeyMokeyKingExecutor : DefaultExecutor
    

    {
        public class CardId
        {
            public const int 青眼白龙 = 120120000;
            public const int 破坏之剑士 = 120170000;
            public const int 黑魔术师 = 120130000;
            public const int 真红眼黑龙 = 120125001;
            public const int 恶魔召唤 = 120145000;
            public const int 人造人 = 120155000;
            public const int 连击龙 = 120110001;
            public const int 七星道魔术师 = 120105001;
            public const int 雅灭鲁拉 = 120120029;
            public const int 耳语妖精 = 120120018;
            public const int 神秘庄家 = 120105006;
            public const int 火星心少女 = 120145014;
            public const int 斗牛士 = 120170035;
            public const int 凤凰龙 = 120110009;
            public const int 七星道法师 = 120130016;
            public const int sionmax = 120150007;
            public const int 对死者的供奉 = 120151023;
            public const int 落穴 = 120150019;
            public const int 暗黑释放 = 120105013;
           
        }



        public MokeyMokeyKingExecutor(GameAI ai, Duel duel)
            : base(ai, duel)
        {
            AddExecutor(ExecutorType.SpSummon);
            AddExecutor(ExecutorType.Activate, CardId.七星道法师, 七星道法师Effect);
            AddExecutor(ExecutorType.Summon, CardId.青眼白龙, DefaultMonsterSummon);
            AddExecutor(ExecutorType.Summon, CardId.破坏之剑士, DefaultMonsterSummon);
            AddExecutor(ExecutorType.Summon, CardId.恶魔召唤, DefaultMonsterSummon);
            AddExecutor(ExecutorType.Summon, CardId.连击龙, DefaultMonsterSummon);
            AddExecutor(ExecutorType.Summon, CardId.雅灭鲁拉, DefaultMonsterSummon);
            AddExecutor(ExecutorType.Summon, CardId.黑魔术师, DefaultMonsterSummon);
            AddExecutor(ExecutorType.Summon, CardId.真红眼黑龙, DefaultMonsterSummon);
            AddExecutor(ExecutorType.Summon, CardId.七星道魔术师, DefaultMonsterSummon);
            AddExecutor(ExecutorType.Summon, CardId.人造人, DefaultMonsterSummon);
            AddExecutor(ExecutorType.Summon, CardId.神秘庄家);
            AddExecutor(ExecutorType.Activate, CardId.神秘庄家);
            AddExecutor(ExecutorType.SpellSet, CardId.暗黑释放);
            AddExecutor(ExecutorType.SpellSet, CardId.落穴);
            AddExecutor(ExecutorType.Activate, CardId.落穴, 落穴Effect);
            AddExecutor(ExecutorType.Activate, CardId.对死者的供奉, 死供Effect);
            AddExecutor(ExecutorType.SpellSet, CardId.对死者的供奉);
            AddExecutor(ExecutorType.MonsterSet, CardId.凤凰龙, monsterset);
            AddExecutor(ExecutorType.MonsterSet, CardId.火星心少女, monsterset);
            AddExecutor(ExecutorType.MonsterSet, CardId.七星道法师, monsterset);
            AddExecutor(ExecutorType.MonsterSet, CardId.耳语妖精, monsterset);
            AddExecutor(ExecutorType.Summon, CardId.七星道法师);
            AddExecutor(ExecutorType.Summon, CardId.凤凰龙);
            AddExecutor(ExecutorType.Activate, CardId.凤凰龙);
            AddExecutor(ExecutorType.SummonOrSet, DefaultMonsterSummon);
            AddExecutor(ExecutorType.Repos, DefaultMonsterRepos);
            AddExecutor(ExecutorType.SpellSet);           
            //AddExecutor(ExecutorType.Activate, CardId.sionmax, sionmaxEffect);
            AddExecutor(ExecutorType.Activate, CardId.耳语妖精, 耳语妖精Effect);
            AddExecutor(ExecutorType.Activate, CardId.火星心少女, 火星心少女Effect);
            AddExecutor(ExecutorType.Activate, CardId.连击龙);
            AddExecutor(ExecutorType.Activate, CardId.七星道魔术师);
            //AddExecutor(ExecutorType.Activate, CardId.斗牛士, 斗牛士Effect);
            
            AddExecutor(ExecutorType.Activate, DefaultDontChainMyself);

        }



        private List<int> HintMsgForEnemy = new List<int>
        {
            HintMsg.Release, HintMsg.Destroy, HintMsg.Remove, HintMsg.ToGrave, HintMsg.ReturnToHand, HintMsg.ToDeck,
            HintMsg.FusionMaterial, HintMsg.SynchroMaterial, HintMsg.XyzMaterial, HintMsg.LinkMaterial, HintMsg.Disable
        };
        private List<int> HintMsgForMaxSelect = new List<int>
        {
            HintMsg.SpSummon, HintMsg.ToGrave, HintMsg.AddToHand, HintMsg.ToDeck, HintMsg.Destroy
        };

        public override IList<ClientCard> OnSelectCard(IList<ClientCard> _cards, int min, int max, int hint, bool cancelable)
        {
            if (Duel.Phase == DuelPhase.BattleStart)
                return null;
            if (AI.HaveSelectedCards())
                return null;

            IList<ClientCard> selected = new List<ClientCard>();
            IList<ClientCard> cards = new List<ClientCard>(_cards);
            if (max > cards.Count)
                max = cards.Count;

            if (HintMsgForEnemy.Contains(hint))
            {
                IList<ClientCard> enemyCards = cards.Where(card => card.Controller == 1).ToList();

                // select enemy's card first
                while (enemyCards.Count > 0 && selected.Count < max)
                {
                    ClientCard card = enemyCards[Program.Rand.Next(enemyCards.Count)];
                    selected.Add(card);
                    enemyCards.Remove(card);
                    cards.Remove(card);
                }
            }

            if (HintMsgForMaxSelect.Contains(hint))
            {
                // select max cards
                while (selected.Count < max)
                {
                    ClientCard card = cards[Program.Rand.Next(cards.Count)];
                    selected.Add(card);
                    cards.Remove(card);
                }
            }
            return selected;
        }
        public override bool OnSelectHand()
        {
            // go first
            return true;
        }
        public  bool monsterset()
        {
            if (Duel.Turn == 1)
            {
                return true;
            }
            else if (Bot.HasInHand(new[] {
                CardId.七星道魔术师,
                CardId.连击龙,
                CardId.青眼白龙,
                CardId.人造人,
                CardId.恶魔召唤,
                CardId.雅灭鲁拉,
                CardId.破坏之剑士,
                CardId.真红眼黑龙,
                CardId.黑魔术师
                }))
                return false;
            return true;
        }

        private bool 耳语妖精Effect()
        {

            IList<ClientCard> targets = new List<ClientCard>();
            foreach (ClientCard card in Enemy.GetGraveyardMonsters())
            {
                if (card.Level <= 4)
                    targets.Add(card);
            }
            return true;

        }
        private bool 七星道法师Effect()
        {
            AI.SelectCard(Enemy.GetMonsters().GetHighestAttackMonster());
            return true;
        }
        private bool 落穴Effect()
        {
            foreach (ClientCard n in Duel.LastSummonedCards)
            {
                if (n.Attack >= 1900)
                    return true;
            }
            return false;
        }
        private bool 死供Effect()
        {
            if (Util.IsOneEnemyBetterThanValue(1900, true))
            {
                foreach (ClientCard m in Bot.Hand)
                    AI.SelectCard(m);
                AI.SelectNextCard(Enemy.GetMonsters().GetHighestAttackMonster());
                return true;
            }
            return false;
        }

        private bool 火星心少女Effect()
        {
            foreach (ClientCard m in Bot.Hand)
            AI.SelectCard(m); 
            AI.SelectNextCard(Enemy.GetMonsters().GetHighestAttackMonster());
            AI.SelectYesNo(true);
            return true;
        }


   
    }
}