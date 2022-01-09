---
{
  "title": "Lorem Ipsum",
  "tags": ["Markdown", "Theme"]
}
---

Lorem ipsum dolor sit amet, consectetur adipiscing elit. Praesent ut quam ac sem
tincidunt congue. Aenean vestibulum mi enim. Donec elementum turpis in tempor
blandit. In imperdiet consectetur metus id aliquam. Nulla vel risus molestie,
consequat ipsum eget, congue enim. Nam nec nibh pharetra, faucibus odio
vestibulum, imperdiet neque. Fusce vel finibus ligula. Nam viverra maximus
libero eu posuere. Nullam hendrerit suscipit eleifend. Vestibulum finibus mi a
nunc dignissim bibendum. Maecenas pellentesque porttitor imperdiet. Sed auctor
augue in quam sagittis varius. Etiam venenatis sem eget turpis aliquet sodales.
Curabitur pulvinar consectetur placerat. Aenean egestas ipsum a nisi imperdiet,
eget aliquet ligula egestas. Cras ut arcu quis quam tempor tincidunt nec ut
neque.

Duis odio erat, sodales ac `dolor` quis, viverra vehicula odio. Duis at leo non
eros posuere rutrum ut ac nisl. Praesent elementum nunc sapien, quis tristique
nibh tristique a. Nunc `dictum` consectetur neque sed condimentum. Nunc
condimentum, magna ut varius `volutpat`, mi dui tempus magna, in feugiat est
turpis eget nisi. Nam non nisi bibendum quam tristique gravida. Pellentesque
dui leo, imperdiet feugiat `porta` pulvinar, egestas consectetur ex. Sed viverra
iaculis mattis. Nunc pulvinar, lectus a ultricies porttitor, lorem augue
suscipit metus, sit amet `aliquam` diam lectus in enim. Ut vehicula auctor risus
`vitae` elementum. Cras nec `risus` interdum erat dictum lacinia quis non mi.
Quisque non est sed nisi fringilla congue eget et nisi.

```coq
(* A type for infinite streams *)
CoInductive stream (A:Type) :=
  | scons : A -> stream A -> stream A.

Implicit Arguments scons.

Definition stream_hd {A:Type} (s:stream A) :=
  match s with scons x _ => x end.

Definition stream_tl {A:Type} (s:stream A) :=
  match s with scons _ s' => s' end.

(* Getting the Nth element of a stream is a regular fixpoint decreasing on n *)
Fixpoint Nth {A:Type} (n:nat) (s:stream A) : A :=
  match n with
      O => stream_hd s
    | S n' => Nth n' (stream_tl s)
  end.

(* This function is useful to force unfolding a stream one level *)
Definition stream_decompose {A:Type} (s:stream A) :=
  match s with scons x s' => scons x s' end.

(* This lemma tells us that stream_decompose is an identity *)
Lemma stream_dec {A:Type} : forall s:stream A, s = stream_decompose s.
Proof.
  intros s.
  destruct s.
  simpl.
  trivial.
Qed.
```

Lorem ipsum dolor sit amet, consectetur adipiscing elit. Pellentesque faucibus
tellus quis turpis pharetra, quis feugiat orci semper. Praesent in imperdiet
eros, in accumsan lectus. Proin sit amet vehicula dui, vestibulum vehicula orci.
Praesent accumsan non nunc eu vulputate. Nunc rhoncus enim vel fermentum mattis.
In a nisi arcu. Aliquam eu iaculis lectus. Donec tincidunt sapien vel elit
tristique, non faucibus nulla auctor. Phasellus porta sagittis lectus eget
aliquam.

Vivamus risus orci, pharetra tempor accumsan non, vehicula eget eros. Quisque
sollicitudin leo in risus facilisis tempor. Integer sit amet eros neque. Donec
non tellus a magna pharetra euismod tristique ac nulla. Nullam quis urna ligula.
Sed luctus tellus lectus, ac molestie enim posuere nec. In fermentum tristique
elit, ut blandit arcu euismod consequat.

## The standard Lorem Ipsum passage, used since the 1500s

"Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum."

## Section 1.10.32 of "de Finibus Bonorum et Malorum", written by Cicero in 45 BC

"Sed ut perspiciatis unde omnis iste natus error sit voluptatem accusantium doloremque laudantium, totam rem aperiam, eaque ipsa quae ab illo inventore veritatis et quasi architecto beatae vitae dicta sunt explicabo. Nemo enim ipsam voluptatem quia voluptas sit aspernatur aut odit aut fugit, sed quia consequuntur magni dolores eos qui ratione voluptatem sequi nesciunt. Neque porro quisquam est, qui dolorem ipsum quia dolor sit amet, consectetur, adipisci velit, sed quia non numquam eius modi tempora incidunt ut labore et dolore magnam aliquam quaerat voluptatem. Ut enim ad minima veniam, quis nostrum exercitationem ullam corporis suscipit laboriosam, nisi ut aliquid ex ea commodi consequatur? Quis autem vel eum iure reprehenderit qui in ea voluptate velit esse quam nihil molestiae consequatur, vel illum qui dolorem eum fugiat quo voluptas nulla pariatur?"

## 1914 translation by H. Rackham

"But I must explain to you how all this mistaken idea of denouncing pleasure and praising pain was born and I will give you a complete account of the system, and expound the actual teachings of the great explorer of the truth, the master-builder of human happiness. No one rejects, dislikes, or avoids pleasure itself, because it is pleasure, but because those who do not know how to pursue pleasure rationally encounter consequences that are extremely painful. Nor again is there anyone who loves or pursues or desires to obtain pain of itself, because it is pain, but because occasionally circumstances occur in which toil and pain can procure him some great pleasure. To take a trivial example, which of us ever undertakes laborious physical exercise, except to obtain some advantage from it? But who has any right to find fault with a man who chooses to enjoy a pleasure that has no annoying consequences, or one who avoids a pain that produces no resultant pleasure?"

Section 1.10.33 of "de Finibus Bonorum et Malorum", written by Cicero in 45 BC

"At vero eos et accusamus et iusto odio dignissimos ducimus qui blanditiis praesentium voluptatum deleniti atque corrupti quos dolores et quas molestias excepturi sint occaecati cupiditate non provident, similique sunt in culpa qui officia deserunt mollitia animi, id est laborum et dolorum fuga. Et harum quidem rerum facilis est et expedita distinctio. Nam libero tempore, cum soluta nobis est eligendi optio cumque nihil impedit quo minus id quod maxime placeat facere possimus, omnis voluptas assumenda est, omnis dolor repellendus. Temporibus autem quibusdam et aut officiis debitis aut rerum necessitatibus saepe eveniet ut et voluptates repudiandae sint et molestiae non recusandae. Itaque earum rerum hic tenetur a sapiente delectus, ut aut reiciendis voluptatibus maiores alias consequatur aut perferendis doloribus asperiores repellat."

## 1914 translation by H. Rackham

"On the other hand, we denounce with righteous indignation and dislike men who are so beguiled and demoralized by the charms of pleasure of the moment, so blinded by desire, that they cannot foresee the pain and trouble that are bound to ensue; and equal blame belongs to those who fail in their duty through weakness of will, which is the same as saying through shrinking from toil and pain. These cases are perfectly simple and easy to distinguish. In a free hour, when our power of choice is untrammelled and when nothing prevents our being able to do what we like best, every pleasure is to be welcomed and every pain avoided. But in certain circumstances and owing to the claims of duty or the obligations of business it will frequently occur that pleasures have to be repudiated and annoyances accepted. The wise man therefore always holds in these matters to this principle of selection: he rejects pleasures to secure other greater pleasures, or else he endures pains to avoid worse pains."